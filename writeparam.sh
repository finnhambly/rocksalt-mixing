#!/bin/bash
cat > MgO.param <<EOL
  comment            : MgO
  task               : SinglePoint  ! don't change the geometry
  xc_functional      : LDA
  spin_polarized     : false
  cut_off_energy     : 800 eV
  grid_scale         : 2.0000000000

  ! Set convergence criteria and max. iterations
  elec_energy_tol    : 0.0000001
  max_scf_cycles     : 60

  fix_occupancy      : false ! treat system as metallic

  calculate_stress   : true

  ! Optimisation settings for max. speed
  opt_strategy       : speed
  page_wvfns         :   0

  ! Fine-tuning for the groundstate algorithm
  metals_method      : dm
  mixing_scheme      : pulay
  smearing_width     : 0.2
  mix_history_length : 30
EOL
