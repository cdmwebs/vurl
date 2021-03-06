class VurlsController < ApplicationController
  # GET /vurls
  # GET /vurls.xml
  def index
    redirect_to new_vurl_path
  end

  # GET /vurls/1
  # GET /vurls/1.xml
  def show
    @vurl = Vurl.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vurl }
    end
  end

  # GET /vurls/stats/AA
  def stats
    @vurl = Vurl.find_by_slug(params[:slug])
    if @vurl.nil?
      load_recent_popular_vurls
      load_most_popular_vurls
      render :template => 'vurls/not_found' and return
    end
    respond_to do |format|
      format.html { render :show }
      format.xml  { render :xml => @vurl }
    end
  end

  # GET /vurls/new
  # GET /vurls/new.xml
  def new
    @vurl = Vurl.new(:url => params[:url])
    load_recent_popular_vurls

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vurl }
    end
  end

  # GET /vurls/1/edit
  def edit
    redirect_to new_vurl_path
  end

  # POST /vurls
  # POST /vurls.xml
  def create
    @vurl = Vurl.new(params[:vurl])
    @vurl.ip_address = request.remote_ip

    load_recent_popular_vurls

    respond_to do |format|
      if @vurl.save
        flash[:notice] = 'Vurl was successfully created.'
        format.html { redirect_to(@vurl) }
        format.xml  { render :xml => @vurl, :status => :created, :location => @vurl }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vurl.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vurls/1
  # PUT /vurls/1.xml
  def update
    redirect_to new_vurl_path
  end

  # DELETE /vurls/1
  # DELETE /vurls/1.xml
  def destroy
    redirect_to new_vurl_path
  end

  def redirect
    if vurl = Vurl.find_by_slug(params[:slug])
      click = Click.new(:vurl => vurl, :ip_address => request.env["REMOTE_ADDR"], :user_agent => request.user_agent, :referer => request.referer)
      unless click.save
        logger.warn "Couldn't create Click for Vurl (#{vurl.inspect}) because it had the following errors: #{click.errors}"
      end
      redirect_to vurl.url
    else
      load_recent_popular_vurls
      load_most_popular_vurls
      render :template => 'vurls/not_found'
    end
  end

  def random
    redirect_to Vurl.random.url
  end

  protected

  def load_recent_popular_vurls
    @recent_popular_vurls = Vurl.since(7.days.ago).most_popular
  end

  def load_most_popular_vurls
    @most_popular_vurls = Vurl.most_popular
  end
end
