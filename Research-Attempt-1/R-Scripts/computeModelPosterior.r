#Computing Posterior Probability
computeModelPosterior_deriv<-function(t_total, t, gamma, t_total_info, flag){
  #t_total        : The value of t_total in P(t_total | t)
  #t              : The value of t in P(t_total | t)
  #gamma           : gamma parameter (Not used in generating these predictions, leftover from implementation of original model)
  #t_total_info   : a Domain Size x 2 vector, 1st column are t_total values, 
  #                 2nd is P(t_total)
  #flag           : The story (cake, bus, drive, train) we're calculating posterior for
  #                             1     2     3      4
  
  startIndex = 0
  
  #Vector of all t_total values
  t_total_vals_vec = t_total_info[1]
  
  #Vector of all t_total_probs
  t_total_probs_vec = t_total_info[2]
  num_rows = nrow(t_total_vals_vec)
  
  for(i in (1:num_rows)){
    if(t_total_vals[i] >= t){
      startIndex = i
      break
    }
  }
  
  para = 0.3
  
  #The cake, bus, and drive stories all use the same utility function
  if(flag == 1 || flag == 3 || flag == 2){
    if(t_total - t != 0){
      util = exp(1/(t_total - t))
      util = util / (exp((t_total - t)*para) + util)
    }
    else {
      util = 1
    }
    likelihood = (1/t_total) * util
  }
  # The utitlity function for the train story
  else if(flag == 4){
    util = exp(t_total-t)
    util = util / (exp((1/(t_total - t))*para) + util)
    likelihood = (1/t_total) * util
  }
  
  else likelihood = 1/t_total #Otherwise generate non-social predictions
  
  t_prior = 0
  given_t_total_prior = 0
  
  #P(t) = sum of p(t_total)/t_total
  for(i in (1:num_rows)){
    t_prior = t_prior + (t_total_probs_vec[i,]/t_total_vals_vec[i,])
    #Storing the t_total probability for the t_total passed as the function's parameter
    if(t_total_vals_vec[i,] == t_total) given_t_total_prior = t_total_probs_vec[i,]
  }
  
  #Bayes Rules
  return (likelihood * given_t_total_prior) / t_prior
}
# 