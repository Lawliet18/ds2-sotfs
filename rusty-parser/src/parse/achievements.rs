use scraper::{Html, Selector};
use uuid::Uuid;

use crate::Result;

pub(crate) fn achievements(html: &Html) -> Result<Vec<Achievement>> {
    // select all H3 elements
    let h3_selector = Selector::parse("div#tabChecklists h3[id]").unwrap();
    // and select all UL elements
    let ul_selector = Selector::parse("div#tabChecklists ul[id].panel-collapse.collapse").unwrap();

    let headings = html.select(&h3_selector).collect::<Vec<_>>();
    let lists = html.select(&ul_selector).collect::<Vec<_>>();

    assert_eq!(
        headings.len(),
        lists.len(),
        "number of headings(h3) should equal number of lists(ul)"
    );
    let li_selector = Selector::parse("li[data-id]").unwrap();
    let r = regex::Regex::new(r#"<a .+?</a>(.+)<span id="checklist.+</span>"#).unwrap();
    let mut achs = Vec::new();
    for (h, l) in headings.into_iter().zip(lists.into_iter()) {
        let inner_html = h.inner_html();
        let captures = r.captures(&inner_html).expect("regex rule failed");
        let ach_name_html = captures[1].trim().to_string();
        let tasks = {
            l.select(&li_selector)
                .map(|task| Task {
                    id: Uuid::new_v4(),
                    description: task.inner_html().trim().to_owned(),
                })
                .collect::<Vec<_>>()
        };
        achs.push(Achievement {
            id: Uuid::new_v4(),
            name: ach_name_html,
            tasks,
        });
    }
    Ok(achs)
}

#[derive(Debug, serde::Serialize)]
pub(crate) struct Achievement {
    id: Uuid,
    name: String,
    tasks: Vec<Task>,
}
#[derive(Debug, serde::Serialize)]
pub(crate) struct Task {
    id: Uuid,
    description: String,
}
