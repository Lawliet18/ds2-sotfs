use argh::FromArgs;
use scraper::Html;
use std::{fs::File, path::PathBuf, str::FromStr};

mod parse;
type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;
#[derive(Debug, FromArgs)]
/// Html parser for https://xenevel.github.io/dark-souls-2-sotfs-cheat-sheet/
struct Args {
    /// path to a html file
    #[argh(positional)]
    html_file: PathBuf,
    /// html page type, allowed values are ["achievements", "playthrough"]
    #[argh(option, short = 't')]
    page_type: HtmlType,

    /// json output path
    #[argh(option, short = 'o')]
    output_file: PathBuf,
}

#[derive(Debug)]
enum HtmlType {
    Playthrough,
    Achievements,
}
impl FromStr for HtmlType {
    type Err = String;

    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        let s = s.to_lowercase();
        if s.starts_with('p') {
            Ok(HtmlType::Playthrough)
        } else if s.starts_with('a') {
            Ok(HtmlType::Achievements)
        } else {
            Err("expected playthrough or achievements".to_owned())
        }
    }
}

fn main() -> Result<()> {
    let args: Args = argh::from_env();
    let html = std::fs::read_to_string(&args.html_file)?;
    let html = Html::parse_document(&html);

    let file = File::create(&args.output_file)?;
    match args.page_type {
        HtmlType::Playthrough => {
            let structure = crate::parse::playthrough(&html)?;
            serde_json::to_writer_pretty(file, &structure)?;
        }
        HtmlType::Achievements => {
            let structure = crate::parse::achievements(&html)?;
            serde_json::to_writer_pretty(file, &structure)?;
        }
    };
    Ok(())
}
