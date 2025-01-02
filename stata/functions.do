* Function to create a variable and label based on codes and range of variables
capture program drop create_var_based_on_subcodes
program define create_var_based_on_codes
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