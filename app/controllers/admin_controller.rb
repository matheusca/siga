class AdminController < ApplicationController

  # GET /admin
  def index
    @opts = Opt.all
    @stats = [User, Person, Group, Publication, Property, Zone].map { |k| "#{k}: #{k.count}"}

    respond_to do |format|
      format.html   # show.html.erb
      format.xml  { render :xml => @opt }
    end
  end


  # DELETE /opts/1
  # DELETE /opts/1.xml
  def destroy
    @opt = Opt.find(params[:id])
    @opt.destroy

    respond_to do |format|
      format.html { redirect_to(opts_url) }
      format.xml  { head :ok }
    end
  end

  # POST /opts
  # POST /opts.xml
  def create
    @opt = Opt.new(params[:opt])

    respond_to do |format|
      if @opt.save
        flash[:notice] = 'Opt was successfully created.'
        format.html { redirect_to(@opt) }
        format.xml  { render :xml => @opt, :status => :created, :location => @opt }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @opt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /opts/1
  # PUT /opts/1.xml
  def update
    @opt = Opt.find(params[:id])

    respond_to do |format|
      if @opt.update_attributes(params[:opt])
        flash[:notice] = 'Opt was successfully updated.'
        format.html { redirect_to(@opt) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @opt.errors, :status => :unprocessable_entity }
      end
    end
  end


end
