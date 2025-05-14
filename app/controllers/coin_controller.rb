class CoinController < ApplicationController

  def price
    api()
    informacion()
  end

  def compra
    @item = Transaccion.new(trans_params)
    if validacionCompra(@item.usuario, @item.pago, @item.cantidad)
        @item.save
        redirect_to root_path, notice: 'Registro creado exitosamente'
    else
      redirect_to root_path, alert: 'Error al crear el registro'
    end
  end

  def venta
    @item = Transaccion.new(trans_params)
    if validacionVenta(@item.usuario, @item.pago, @item.cantidad)
        @item.save
        redirect_to root_path, notice: 'Registro creado exitosamente'
    else
      redirect_to root_path, alert: 'Error al crear el registro'
    end
  end

  def api
    require 'uri'
    require 'net/http'

    url = URI("https://api.coingecko.com/api/v3/simple/price?vs_currencies=usd&ids=bitcoin&names=bitcoin&symbols=btc&precision=8")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["x-cg-demo-api-key"] = 'CG-fYu9EpXujAQd4tan3SPmNQpb'

    response = http.request(request)
    puts response.read_body
    @bitcoin_data = JSON.parse(response.body)
    @price = @bitcoin_data["bitcoin"]["usd"]
  end

  def informacion
    @Tcompra = Transaccion.where(tipo: "Compra")
    @Tventa = Transaccion.where(tipo: "Venta")
    @usuario = Usuario.find(1)

  end

  private

  def trans_params

      params.permit(:usuario, :monedaR, :monedaE, :cantidad,:pago, :tipo, :precio)
  end

  def validacionCompra (usuario, pago, cantidad)
    @usuario = Usuario.find(usuario)
    @diferencia = @usuario.saldo - pago
    if @diferencia > 0
      @cartera = @usuario.cartera + cantidad
      @usuario.update(saldo: @diferencia, cartera: @cartera)
      return true
    end

  end

  def validacionVenta (usuario, pago, cantidad)
    @usuario = Usuario.find(usuario)
    @diferencia = @usuario.saldo + pago
    @cartera = @usuario.cartera - cantidad
    if @diferencia > 0 && @cartera > 0
      @usuario.update(saldo: @diferencia, cartera: @cartera)
      return true
    end

  end

end
