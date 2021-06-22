use std::{fs::File, path::PathBuf, str::FromStr};

use scraper::{Html, Selector};
use argh::FromArgs;
type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;
#[derive(Debug, FromArgs)]
/// Html parser for https://xenevel.github.io/dark-souls-2-sotfs-cheat-sheet/
struct Args{
    /// path to a html file
    #[argh(positional)]
    html_file: PathBuf,
    /// html page type, allowed values are ["achievements", "playthrough"]
    #[argh(option, short='t')]
    page_type: HtmlType,

    /// json output path
    #[argh(option, short='o')]
    output_file: PathBuf,
}

#[derive(Debug)]
enum HtmlType{
    Playthrough,
    Achievements,
}
impl FromStr for HtmlType{
    type Err = String;

    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        let s = s.to_lowercase();
        if s.starts_with("p"){
            Ok(HtmlType::Playthrough)
        }else if s.starts_with("a"){
            Ok(HtmlType::Achievements)
        }else{
            Err("expected playthrough or achievements".to_owned())
        }
    }
}


fn main() -> Result<()> {
    let args: Args = argh::from_env();
    let html = std::fs::read_to_string(&args.html_file)?;
    let html = Html::parse_document(&html);
    match args.page_type{
        HtmlType::Playthrough => parse_playthrough(html, &args),
        HtmlType::Achievements => todo!("in progress"),
    }
}

fn parse_playthrough(html : Html, args: &Args) -> Result<()>{
    // select all H3 elements
    let h3_selector = Selector::parse("div#tabPlaythrough h3[id]").unwrap();
    // and select all UL elements
    let ul_selector = Selector::parse("div#tabPlaythrough ul.panel-collapse.collapse").unwrap();

    let headings = html.select(&h3_selector).collect::<Vec<_>>();
    let lists = html.select(&ul_selector).collect::<Vec<_>>();

    assert_eq!(
        headings.len(),
        lists.len(),
        "number of headings(h3) should equal number of lists(ul)"
    );
    let heading_link_selector = Selector::parse("a:not(.btn)").unwrap();
    let lists_tasks_selector = Selector::parse("li[data-id]").unwrap();
    let task_text_selector = Selector::parse("span.item_content").unwrap();
    let mut locs = Vec::new();
    for (h, l) in headings.into_iter().zip(lists.into_iter()) {
        let location = {
            if let Some(x) = h.select(&heading_link_selector).next() {
                x.html().trim().to_owned()
            } else {
                // Misc task workaround
                h.children()
                    .nth(1)
                    .expect("no second")
                    .value()
                    .as_text()
                    .expect("as_text returned None")
                    .trim()
                    .to_string()
            }
        };
        let tasks = l
            .select(&lists_tasks_selector)
            .map(|x| {
                x.select(&task_text_selector)
                    .next()
                    .expect("no item_content found!")
                    .inner_html()
                    .trim()
                    .to_owned()
            })
            .collect::<Vec<_>>();
        locs.push(Location {
            name: location,
            tasks,
        });
    }
    let file = File::create(&args.output_file)?;
    serde_json::to_writer_pretty(file, &locs)?;
    Ok(())
}

#[derive(Debug, serde::Serialize)]
struct Location {
    name: String,
    tasks: Vec<String>,
}
