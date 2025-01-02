/*
    Purpose:
    This function creates a new variable based on substrings of ICD codes from a specified range of existing variables. 
    It is particularly useful for identifying records that match specific ICD codes in health data analysis.

    *** NOTE: us this function if you have no "." you want to remove. See other function if you also need to remove a character

    Variables:
    - codes: A string of truncated ICD codes to match (e.g., "1673").
    - var_range: A range of existing variables to search through (e.g., "DX1-DX10").
    - newvar: The name of the new variable to be created (e.g., "icd_match").
    - label: A label for the new variable (e.g., "ICD code match").

    Output:
    - A new variable is created and initialized to 0. It is updated to 1 if any of the variables in the specified range 
      start with the substring of the provided ICD codes.

    Typical Use Case:
    - This function is typically used in health data analysis to identify records that match specific ICD codes. 
      For example, in a study about heat illness, you might want to identify records with ICD codes related to heatstroke.

    Example Usage:
    create_var_based_on_codes, codes("1673") var_range("CPT1-CPT10") newvar("cpt_match") label("CPT code match")

    create_var_based_on_subcodes, codes("51881 51882 51884 7991") var_range("DX1-DX10") newvar("pc_respiratory_dx") label("potential complications - respiratory dx")
*/

* Function to create a variable and label based on codes and range of variables
capture program drop create_var_based_on_subcodes
program define create_var_based_on_subcodes
    syntax , codes(string) var_range(string) newvar(string) label(string)
    
    * Generate the new variable and initialize to 0
    gen `newvar' = 0
    
    * Loop through the range of variables and update based on codes
    foreach var of varlist `var_range' {
        foreach code in `codes' {
            replace `newvar' = 1 if substr(`var', 1, strlen("`code'")) == "`code'"
        }
    }
    
    * Label the new variable
    label var `newvar' "`label'"
end

* Example usage
* create_var_based_on_codes, codes("1673") var_range("DX1-DX10") newvar("icd_match") label("ICD code match")


/*
    Purpose:
    This function creates a new variable based on substrings of ICD codes from a specified range of existing variables. 
    It also cleans the dataset of periods in the ICD codes before processing.

*** NOTE: this function removes a period of the provide range of variables. It is slower than the above function. 

    Variables:
    - codes: A string of truncated ICD codes to match (e.g., "M17"). The input codes should not contain periods.
    - var_range: A range of existing variables to search through (e.g., "DX1-DX10").
    - newvar: The name of the new variable to be created (e.g., "icd_match").
    - label: A label for the new variable (e.g., "ICD code match").

    Output:
    - A new variable is created and initialized to 0. It is updated to 1 if any of the variables in the specified range 
      start with the substring of the provided ICD codes after cleaning periods.

    Typical Use Case:
    - This function is typically used in health data analysis to identify records that match specific ICD codes. 
      For example, in a study about heat illness, you might want to identify records with ICD codes related to heatstroke.

    Example Usage:
    create_var_based_on_subcodes_with_period, codes("M17") var_range("DX1-DX10") newvar("osteoarthritis_knee_cleaned") label("Osteoarthritis of knee (cleaned)")
*/

* Function to create a variable and label based on codes and range of variables, cleaning periods
capture program drop create_var_based_on_subcodes_with_period
program define create_var_based_on_subcodes_with_period
    syntax , codes(string) var_range(string) newvar(string) label(string)
    
    * Generate the new variable and initialize to 0
    gen `newvar' = 0
    
    * Loop through the range of variables and update based on codes
    foreach var of varlist `var_range' {
        * Clean periods from the variable
        gen cleaned_var = subinstr(`var', ".", "", .)
        foreach code in `codes' {
            replace `newvar' = 1 if substr(cleaned_var, 1, strlen("`code'")) == "`code'"
        }
        drop cleaned_var
    }
    
    * Label the new variable
    label var `newvar' "`label'"
end

* Example usage
* create_var_based_on_subcodes_with_period, codes("M17") var_range("DX1-DX10") newvar("osteoarthritis_knee_cleaned") label("Osteoarthritis of knee (cleaned)")