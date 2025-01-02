/*
    Purpose:
    This function creates a new variable based on substrings of ICD codes from specified ranges of existing variables. 
    It first sets the new variable to 1 based on the true range and then sets it back to 0 based on the false range.
    This is useful for excluding more granular searches.

    Variables:
    - codes: A string of truncated ICD codes to match (e.g., "51881 51882 51884 7991"). The input codes should not contain periods.
    - true_range: A range of existing variables to search through for setting the new variable to 1 (e.g., "DX1-DX10").
    - false_range: A range of existing variables to search through for setting the new variable back to 0 (e.g., "DX11-DX20").
    - newvar: The name of the new variable to be created (e.g., "pc_respiratory_dx").
    - label: A label for the new variable (e.g., "potential complications - respiratory dx").

    Output:
    - A new variable is created and initialized to 0. It is updated to 1 if any of the variables in the true range 
      start with the substring of the provided ICD codes and set back to 0 if any of the variables in the false range 
      start with the substring of the provided ICD codes.

    Typical Use Case:
    - This function is typically used in health data analysis to identify records that match specific ICD codes while 
      excluding more granular searches.

    Example Usage:
    create_var_based_on_true_false_ranges, codes("51881 51882 51884 7991") true_range("DX1-DX10") false_range("DX11-DX20") newvar("pc_respiratory_dx") label("potential complications - respiratory dx")
*/

* Function to create a variable based on true and false ranges of ICD codes
capture program drop create_var_based_on_true_false_ranges
program define create_var_based_on_true_false_ranges
    syntax , codes(string) true_range(string) false_range(string) newvar(string) label(string)
    
    * Generate the new variable and initialize to 0
    gen `newvar' = 0
    
    * Loop through the true range of variables and update based on codes
    foreach var of varlist `true_range' {
        foreach code in `codes' {
            replace `newvar' = 1 if substr(`var', 1, strlen("`code'")) == "`code'"
        }
    }
    
    * Loop through the false range of variables and update based on codes
    foreach var of varlist `false_range' {
        foreach code in `codes' {
            replace `newvar' = 0 if substr(`var', 1, strlen("`code'")) == "`code'"
        }
    }
    
    * Label the new variable
    label var `newvar' "`label'"
end

* Example usage
* create_var_based_on_true_false_ranges, codes("51881 51882 51884 7991") true_range("DX1-DX10") false_range("DX11-DX20") newvar("pc_respiratory_dx") label("potential complications - respiratory dx")