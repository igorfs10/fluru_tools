use crate::{
    enums::format_converter::FormatConverter,
    services::{csv_converter::*, json_converter::*, xml_converter::*, yaml_converter::*},
};

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
