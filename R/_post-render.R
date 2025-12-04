library(beepr)
library(groomr) # github.com/sustentarea/groomr
library(here)

# Remove Empty Lines from `README.md` -----

here("README.md") |> remove_blank_line_dups()

# Check If the Script Ran Successfully -----

beep(1)

Sys.sleep(3)
