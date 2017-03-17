function adj_washout_simulation(time_start,time_stop,time_step_size,parameter_index, data_dictionary)

  # run model first to steady state
  XSS = estimate_steady_state(0.001, data_dictionary);

  # set initial conditions to steady state values
  initial_condition_array = XSS;
  number_of_states = length(XSS);
  data_dictionary["initial_condition_array"] = [initial_condition_array; zeros(number_of_states)];

  # Phase 1
  # Run the model for an initial phase
  time_start_phase_1 = 0.0;
  time_stop_phase_1 = 10.0;

  # solve the system equations
    (TP1,XP1) = SolveAdjBalances(time_start_phase_1, time_stop_phase_1, time_step_size,parameter_index,data_dictionary);

  # set the initial condition for Phase 2: inducer added
  initial_condition_array = XP1[end,:];
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # Update control parameters to turn on gene 1: inducer added
  control_parameter_dictionary = data_dictionary["control_parameter_dictionary"];
  control_parameter_dictionary["W_gene_1_RNAP"] = 1.0;
  data_dictionary["control_parameter_dictionary"] = control_parameter_dictionary;

  # Specify the time limits for Phase 2
  time_start_phase_2 = time_stop_phase_1 + time_step_size;
  time_stop_phase_2 = time_start_phase_2 + 60.0;

  # Once again solve the balances
  (TP2,XP2) = SolveAdjBalances(time_start_phase_2, time_stop_phase_2, time_step_size, parameter_index, data_dictionary);


  # Update control parameters to turn off gene 1
  control_parameter_dictionary = data_dictionary["control_parameter_dictionary"];
  control_parameter_dictionary["W_gene_1_RNAP"] = 0.0;
  data_dictionary["control_parameter_dictionary"] = control_parameter_dictionary;

  # set initial condition for Phase 3: model is ran until inducer effects are non-existent
  initial_condition_array = XP2[end,:];
  data_dictionary["initial_condition_array"] = initial_condition_array;

  # Specify the time range
  time_start_phase_3 = time_stop_phase_2 + time_step_size;
  time_stop_phase_3 = time_stop

  # Solve the balances for these conditions
  (TP3,XP3) = SolveAdjBalances(time_start_phase_3,time_stop_phase_3,time_step_size, parameter_index, data_dictionary);

  # Package all the phases together
  X = [XP1; XP2; XP3];
  T = [TP1; TP2; TP3];

  return (T,X);
end

# run -
