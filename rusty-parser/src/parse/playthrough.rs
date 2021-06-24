use crate::Result;
use scraper::{Html, Selector};
use uuid::Uuid;

pub(crate) fn playthrough(html: &Html) -> Result<Vec<Location>> {
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
            .map(|x| Task {
                id: Uuid::new_v4(),
                description: x
                    .select(&task_text_selector)
                    .next()
                    .expect("no item_content found!")
                    .inner_html()
                    .trim()
                    .to_owned(),
            })
            .collect::<Vec<_>>();
        locs.push(Location {
            id: Uuid::new_v4(),
            name: location,
            tasks,
        });
    }
    Ok(locs)
}

#[derive(Debug, serde::Serialize)]
pub(crate) struct Location {
    id: Uuid,
    name: String,
    tasks: Vec<Task>,
}
#[derive(Debug, serde::Serialize)]
pub(crate) struct Task {
    id: Uuid,
    description: String,
}
