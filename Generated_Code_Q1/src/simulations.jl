function open_complex_simulation(time_start,time_stop,time_step_size,data_dictionary)

  # First - run the model to steady-state w/no ATRA forcing -
  XSS = estimate_steady_state(0.001,data_dictionary)

  # Next, set the IC to the steady-state value -
  initial_condition_array = XSS;
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # Grab the control parameters - turn on gene_system =
  control_parameter_dictionary = data_dictionary["control_parameter_dictionary"]
  control_parameter_dictionary["W_gene_1_gene_system"] = 1.0;

  # Solve the model equations -
  (TP1,XP1) = SolveBalances(time_start,time_stop,time_step_size,data_dictionary);

  # Package the two phases together -
  T = TP1;
  X = XP1;

  return (T,X);
end
