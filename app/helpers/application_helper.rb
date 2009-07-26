# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def page_title
    @vurl && !@vurl.title.blank? ?  @vurl.title : "Veez's URL shortener"
  end

  def flasher
    return nil if flash.empty?
    messages = ''
    flash.each_pair do |key, message| 
      messages += content_tag(:div, message, :class => key)
    end
    content_tag(:div, messages, :id => 'infoBar')
  end

  # Thanks to mojombo for his clippy swf
  # http://github.com/mojombo/clippy
  def clippy(text, bgcolor='#FFFFFF')
    html = <<-EOF
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
            width="110"
            height="14"
            id="clippy" >
    <param name="movie" value="/flash/clippy.swf"/>
    <param name="allowScriptAccess" value="always" />
    <param name="quality" value="high" />
    <param name="scale" value="noscale" />
    <param NAME="FlashVars" value="text=#{text}">
    <param name="bgcolor" value="#{bgcolor}">
    <embed src="/flash/clippy.swf"
           width="110"
           height="14"
           name="clippy"
           quality="high"
           allowScriptAccess="always"
           type="application/x-shockwave-flash"
           pluginspage="http://www.macromedia.com/go/getflashplayer"
           FlashVars="text=#{text}"
           bgcolor="#{bgcolor}"
    />
    </object>
    EOF
  end
end
