# comentar las siguientes dos líneas en caso de
# usar la consola de julia
import Pkg; Pkg.activate(".")
Pkg.instantiate()

using Leaflet, Blink # para el mapa y la interfaz
using CSV, DataFrames

function main()
    # leer csv con información
    df_completo = CSV.read("mx.csv", DataFrame)

    # elimina registros faltantes
    df = df_completo[completecases(df_completo), :]

    # filtrar por cantidad de información
    min_población = 1e4#525147
    df = filter(row -> row[:population] < min_población, df)

    # proveedor del mapa
    provider = Leaflet.OSM()

    # Genera cada corrdenada para cada punto
    genera_coordenada(row) = Leaflet.Layer([row[:lng], row[:lat]], marker_size = row[:population]/min_población)
    layers = [ genera_coordenada(row) for row in eachrow(df)]

    # Crea mapa con sus capas
    m = Leaflet.Map(; layers, provider,zoom=4, center = [19.53124, -96.91589])

    # genera una venta para visualizar
    w = Blink.Window()
    # agrega al cuerpo el mapa
    body!(w, m)
end

main()
