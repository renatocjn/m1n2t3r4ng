class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)
    respond_to do |format|
      if @device.save
        format.html { redirect_to :root, notice: 'Dispositivo criado com sucesso.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html do 
          errorString = gen_error_string @device
          redirect_to :root, alert: errorString 
        end
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to :root, notice: 'Dispositivo atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html do 
          errorString = gen_error_string @device
          redirect_to :root, alert: errorString 
        end
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to :root, notice: 'Dispositivo destruído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:name, :hostname, :description)
    end
end