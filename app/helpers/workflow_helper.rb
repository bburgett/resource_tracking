module WorkflowHelper

  #TODO write integration test that just walks through these
  # following links and testing for the right active scaffold name heading
  @@map = { "start" => "projects", "projects" => "funding_sources", "funding_sources" => "providers",
            "providers" => "activities" , "activities" => "show"}

  def workflow_start
    next_workflow_path "start"
  end

  def next_workflow_path current_model
    '/'+next_workflow_path_wo_slash(current_model)
  end

  def next_workflow_path_wo_slash current_model
    'data_requests/'+@@map[current_model]
  end

end
