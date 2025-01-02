# Understanding Subcodes in ICD Coding with True and False Ranges

## Example: Osteoarthritis of Knee

ICD codes are structured in a hierarchical manner, where subcodes provide more specific details about a condition. Here is an example of how subcodes work for osteoarthritis of the knee:

- **M17**: Osteoarthritis of knee
  - **M17.0**: Bilateral primary osteoarthritis of knee
  - **M17.1**: Unilateral primary osteoarthritis of knee
    - **M17.10**: Unilateral primary osteoarthritis, unspecified knee
    - **M17.11**: Unilateral primary osteoarthritis, right knee
    - **M17.12**: Unilateral primary osteoarthritis, left knee

## Logic of Subcodes

The logic of subcodes is based on the hierarchical structure of ICD codes. The main code (e.g., M17) represents a general condition, while subcodes (e.g., M17.0, M17.1) provide more specific details. Further subcodes (e.g., M17.10, M17.11, M17.12) offer even finer granularity.

## Benefits of Automatic Matching

Automatically matching the input character lengths when searching for ICD codes offers several benefits:

1. **Error Prevention**: By automatically matching the length of the input codes, the function prevents errors that can occur when manually setting the length for each code. This ensures that the correct substring is always matched.
   
2. **Efficiency**: Automating the matching process reduces the need for long and complex conditional statements. For example, manually stringing together conditions like `substr(DX, 1, 3) == "M17"` can be error-prone and inefficient. The function simplifies this by handling the matching logic internally.

3. **Consistency**: Automatic matching ensures consistent results across different datasets and variables. This is particularly important when dealing with large datasets where manual matching would be impractical.

4. **Multiple Strings at Once**: The function allows for matching multiple ICD codes at once, making it highly efficient for identifying conditions that may be represented by several related codes.

## Handling Periods in ICD Codes

In some datasets, ICD codes may include periods (e.g., "M17.0"). To ensure accurate matching, the input codes should not contain periods. Additionally, we provide a function that cleans the dataset of periods before processing.

## Example Usage

Here is an example of how the functions can be used to match ICD codes:

```stata
create_var_based_on_true_false_ranges, codes("51881 51882 51884 7991") true_range("DX1-DX10") false_range("DX11-DX20") newvar("pc_respiratory_dx") label("potential complications - respiratory dx")