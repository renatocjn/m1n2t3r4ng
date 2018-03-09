class MonitoredServicesController < ApplicationController
  before_action :set_monitored_service, only: [:show, :edit, :update, :destroy]
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
        format.html { redirect_to :root, notice: 'Monitoramento iniciado com sucesso.' }
      else
        format.html { redirect_to :root, alert: "Erros ao criar monitoramento" }
      end
    end
  end

  # PATCH/PUT /monitored_services/1
  # PATCH/PUT /monitored_services/1.json
  def update
    respond_to do |format|
      if @monitored_service.update(monitored_service_params)
        format.html { redirect_to @monitored_service, notice: 'Monitored service was successfully updated.' }
        format.json { render :show, status: :ok, location: @monitored_service }
      else
        format.html { render :edit }
        format.json { render json: @monitored_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monitored_services/1
  # DELETE /monitored_services/1.json
  def destroy
    @monitored_service.destroy
    respond_to do |format|
      format.html { redirect_to :root, notice: 'Monitored service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monitored_service
      @monitored_service = MonitoredService.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monitored_service_params
      params.require(:monitored_service).permit(:service_type, :host, :port, :description)
    end
end
