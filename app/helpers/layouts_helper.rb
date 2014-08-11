module LayoutsHelper

  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    output = render(:file => "layouts/#{layout}")
    self.output_buffer = ActionView::OutputBuffer.new(output)
  end

  def get_avator_url(id, size)
    "https://graph.facebook.com/" + id.to_s + "/picture?width=" + size.to_s + "&height=" + size.to_s
  end

end
