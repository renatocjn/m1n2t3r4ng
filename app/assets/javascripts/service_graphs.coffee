$(document).on "click", ".render_service_graph", () ->
  $("#graph_service_id").attr("value", $(this).data("service"))
  $("#render_graph").trigger("click")

#TODO Ver se isso funciona se o servidor estiver sem internet
$(document).on "click", "#render_graph", ->
  jQuery.ajax "/monitored_services/"+$("#graph_service_id").val()+"/history.json",
    dataType: "json"
    type: "get"
    data:
      start_date: $("#graph_begin").val()
      end_date: $("#graph_end").val()
    beforeSend: ->
      $("#render_graph").attr("disable", true)
    error: (jqXHR, textStatus, errorThrown) ->
      if errorThrown == "Not Found"
        alert "Serviço inválido"
      console.log(errorThrown)
      console.log(textStatus)
      console.log(jqXHR)
    success: (data, textStatus, jqXHR) ->
      delay_trace =
        x: data.map((elem) -> elem["created_at"])
        y: data.map((elem) -> elem["delay"]*1000.0)
        type: 'scatter'
        name: "Latência"
      delivery_ratio_trace =
        x: data.map((elem) -> elem["created_at"])
        y: data.map((elem) -> elem["delivery_ratio"])
        type: 'scatter'
        name: "Taxa de entrega"
        yaxis: "y2"
      data = [delay_trace, delivery_ratio_trace]
      layout =
        height: "80%"
        width: "80%"
        yaxis:
          title: "Latência (Millissegundos)"
        yaxis2:
          title: "Taxa de entrega (%)"
          overlaying: 'y'
          side: 'right'
          dtick: 0.1
          tickformat: '.0%',
          range: [-0.05, 1.05]
        legend:
          orientation: "h"
        margin:
          t: 30
          b: 30
      Plotly.newPlot("graph", data, layout).then ->
        $("#render_graph").attr("disable", false)

window.onresize = () ->
    Plotly.Plots.resize("graph");

$(document).on "hidden.bs.modal", "#graphsModal", ->
  $("#graph_begin, #graph_end").val("")
  $("#render_graph").attr("disable", false)
  $("#graph").empty()