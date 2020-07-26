module AdminHelper

  def link_to_accept_agent_request(request_id)
    link_to 'Accept', newagent_path(id: request_id), class:'btn btn-success btn-xs'
  end

end
