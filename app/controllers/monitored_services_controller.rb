class MonitoredServicesController < ApplicationController
  include SetupPanelVariablesConcern
  
  before_action :set_monitored_service, only: [:show, :edit, :update, :destroy, :history]
  before_filter :authorize

  # GET /monitored_services
  # GET /monitored_services.json
  def index
    @monitored_services = MonitoredService.all
  end

  # GET /monitored_services/1
  # GET /monitored_services/1.json
  def show
  end

  # GET /monitored_services/new
  def new
    @monitored_service = MonitoredService.new
  end

  # GET /monitored_services/1/edit
  def edit
  end

  # POST /monitored_services
  # POST /monitored_services.json
  def create
    @monitored_service = MonitoredService.new(monitored_service_params)
    respond_to do |format|
      if @monitored_service.save
        format.html { redirect_to :root }
        format.json { render :show, status: :created, location: @monitored_service }
      else
        format.html do 
          errorString = gen_error_string @monitored_service
          redirect_to :root, alert: errorString 
        end
        format.json { render json: @monitored_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monitored_services/1
  # PATCH/PUT /monitored_services/1.json
  def update
    respond_to do |format|
      if @monitored_service.update(monitored_service_params)
        format.html { redirect_to :root }
        format.json
      else
        format.html do
          errorString = gen_error_string @monitored_service
          redirect_to :root, alert: errorString 
        end
        format.json { render json: @monitored_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monitored_services/1
  # DELETE /monitored_services/1.json
  def destroy
    @monitored_service.destroy
    respond_to do |format|
      format.html { redirect_to :root }
      format.json { head :no_content }
    end
  end
  
  # GET /monitored_services/1/force_ping
  # GET /monitored_services/force_ping
  def force_ping
    if params[:id].blank?
      StartPingingServicesJob.perform_now
    else
      service = MonitoredService.find_by_id(params[:id])
      PingServiceJob.perform_now service unless service.nil?
    end
    setup_panel_variables # Needs to be here to get updated values after ping
    render "dashboard/refresh_panel"
  end
  
  # GET /monitored_services/1/history
  def history
    start_date = params[:start_date].blank? ? @monitored_service.monitored_service_logs.minimum(:created_at) : Time.zone.parse(params[:start_date]).in_time_zone
    end_date = params[:end_date].blank? ? @monitored_service.monitored_service_logs.maximum(:created_at) : Time.zone.parse(params[:end_date])
    
    @monitored_service_logs = @monitored_service.monitored_service_logs.where("created_at >= ?", start_date).where("created_at <= ?", end_date).order(:created_at)
    render json: {teste: 1, teste2: 2}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monitored_service
      @monitored_service = MonitoredService.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monitored_service_params
      params.require(:monitored_service).permit(:name, :service_type, :warning_delay, :host, :port, :description, :force_create, :device_id)
    end
end
