use crate::{
    enums::format_converter::FormatConverter,
    services::{
        csv_converter::*, hdoc_request::*, json_converter::*, xml_converter::*, yaml_converter::*,
    },
};

#[flutter_rust_bridge::frb(dart_async)]
pub async fn make_request(input: String) -> Result<String, String> {
    match parse_heredoc_request(&input) {
        Ok(request_data) => {
            let result = send_request(&request_data).await;
            match result {
                Ok(result) => {
                    let mut output = format!("Status Code: {}\n", result.status_code);
                    output.push_str("Headers:\n");
                    for (k, v) in result.headers {
                        output.push_str(&format!("{}: {}\n", k, v));
                    }
                    output.push_str("\nBody:\n");
                    output.push_str(&result.body);
                    Ok(output)
                }
                Err(e) => Err(format!("Error executing request: {}", e)),
            }
        }
        Err(e) => Err(format!("Error parsing request: {}", e)),
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn convert_text_format(
    input: String,
    input_format: i32,
    output_format: i32,
) -> Result<String, String> {
    let input_type = FormatConverter::from(input_format);
    let output_type = FormatConverter::from(output_format);
    match (input_type, output_type) {
        (FormatConverter::Json, FormatConverter::Json) => pretty_json(&input),
        (FormatConverter::Json, FormatConverter::Csv) => json_to_csv(&input),
        (FormatConverter::Json, FormatConverter::Yaml) => json_to_yaml(&input),
        (FormatConverter::Json, FormatConverter::Xml) => json_to_xml(&input),
        (FormatConverter::Csv, FormatConverter::Json) => csv_to_json(&input),
        (FormatConverter::Csv, FormatConverter::Csv) => pretty_csv(&input),
        (FormatConverter::Csv, FormatConverter::Yaml) => csv_to_yaml(&input),
        (FormatConverter::Csv, FormatConverter::Xml) => csv_to_xml(&input),
        (FormatConverter::Csv, FormatConverter::Csv) => pretty_csv(&input),
        (FormatConverter::Csv, FormatConverter::Yaml) => csv_to_yaml(&input),
        (FormatConverter::Csv, FormatConverter::Xml) => csv_to_xml(&input),
        (FormatConverter::Yaml, FormatConverter::Json) => yaml_to_json(&input),
        (FormatConverter::Yaml, FormatConverter::Csv) => yaml_to_csv(&input),
        (FormatConverter::Yaml, FormatConverter::Yaml) => pretty_yaml(&input),
        (FormatConverter::Yaml, FormatConverter::Xml) => yaml_to_xml(&input),
        (FormatConverter::Xml, FormatConverter::Json) => xml_to_json(&input),
        (FormatConverter::Xml, FormatConverter::Csv) => xml_to_csv(&input),
        (FormatConverter::Xml, FormatConverter::Yaml) => xml_to_yaml(&input),
        (FormatConverter::Xml, FormatConverter::Xml) => pretty_xml(&input),
    }
}
