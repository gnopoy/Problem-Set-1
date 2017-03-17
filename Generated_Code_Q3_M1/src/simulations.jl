function washout_simulation(time_start,time_stop,time_step_size,data_dictionary)

  # First - run the model to steady-state w/no ATRA forcing -
  XSS = estimate_steady_state(0.001,data_dictionary)

  # Next, set the IC to the steady-state value -
  initial_condition_array = XSS;
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # Phase 1: Run the model 1/4 of the final time w/o ATRA
  # Run the model for a section of time w/no ATRA forcing -
  time_start_phase_1 = 0.0;
  time_stop_phase_1 = 4.0;

  # Solve the model equations -
  (TP1,XP1) = SolveBalances(time_start_phase_1,time_stop_phase_1,time_step_size,data_dictionary);

  # Phase 2: addition of inducer
  initial_condition_array = XP1[end,:];
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # update the expression of system -
  control_parameter_dictionary = data_dictionary["control_parameter_dictionary"]
  control_parameter_dictionary["W_gene_1_RNAP"] = 0.4
  data_dictionary["control_parameter_dictionary"] = control_parameter_dictionary

  # Run the model for a section of time -
  time_start_phase_2 = time_stop_phase_1+time_step_size
  time_stop_phase_2 = time_start_phase_2 + 6.0

  # Solve the model equations -
  (TP2,XP2) = SolveBalances(time_start_phase_2,time_stop_phase_2,time_step_size,data_dictionary);

  # Washout -
  initial_condition_array = XP2[end,:];
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # turn off gene_1 or washout inducer
  control_parameter_dictionary = data_dictionary["control_parameter_dictionary"]
  control_parameter_dictionary["W_gene_1_RNAP"] = 0.0
  data_dictionary["control_parameter_dictionary"] = control_parameter_dictionary

  # Phase 3
  time_start_phase_3 = time_stop_phase_2+time_step_size
  time_stop_phase_3 = time_stop
  (TP3,XP3) = SolveBalances(time_start_phase_3,time_stop_phase_3,time_step_size,data_dictionary);

  # Package the two phases together -
  T = [TP1 ; TP2 ; TP3];
  X = [XP1 ; XP2 ; XP3];

  return (T,X);

end
