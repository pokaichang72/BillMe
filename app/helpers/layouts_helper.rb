module LayoutsHelper

  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    output = render(:file => "layouts/#{layout}")
    self.output_buffer = ActionView::OutputBuffer.new(output)
  end

  def get_avator_url(id, size)
    "https://graph.facebook.com/" + id.to_s + "/picture?width=" + size.to_s + "&height=" + size.to_s
  end

  def state_tag(state)
    state_class = state
    state_class = 'New' if state =~ /^New/
    state_class = 'Dispute' if state =~ /^Dispute/
    state_class = 'Accepted' if state =~ /^Accepted/
    state_class = 'Paid' if state =~ /^Paid/
    state_class = 'Paid q' if state =~ /^Paid\?/
    '<span class="label ' + state_class + '"> ' + state + ' </span>'
  end

end
