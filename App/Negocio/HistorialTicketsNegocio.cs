using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class HistorialTicketsNegocio
    {
        public List<HistorialTickets> ListarPorTicket(int idTicket)
        {
            List<HistorialTickets> lista = new List<HistorialTickets>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = @"
            SELECT 
                H.Id_Historial, H.FechaModificacion, H.Descripcion,
                E.NombreEstado,
                Emp.Nombre + ' ' + Emp.Apellido as NombreModificador
            FROM HistorialTickets H
            INNER JOIN EstadosTicket E ON H.Id_Estado = E.Id_EstadoTicket
            LEFT JOIN Empleado Emp ON H.Modificado_Por = Emp.Id_Empleado
            WHERE H.Id_Ticket = @idTicket
            ORDER BY H.FechaModificacion DESC";

                datos.SetearConsulta(consulta);
                datos.SetearParametro("@idTicket", idTicket);
                datos.EjecutarLectura();

                while (datos.Lector.Read())
                {
                    HistorialTickets aux = new HistorialTickets();
                    aux.Id_Historial = (int)datos.Lector["Id_Historial"];
                    aux.FechaModificacion = (DateTime)datos.Lector["FechaModificacion"];

                    // ----- CORRECCIÓN AQUÍ -----
                    if (!(datos.Lector["Descripcion"] is DBNull))
                        aux.Descripcion = (string)datos.Lector["Descripcion"];

                    aux.EstadoTicket = new EstadosTicket()
                    {
                        NombreEstado = (string)datos.Lector["NombreEstado"]
                    };

                    if (!(datos.Lector["NombreModificador"] is DBNull))
                    {
                        aux.Modificado_Por = new Empleado()
                        {
                            Nombre = (string)datos.Lector["NombreModificador"]
                        };
                    }
                    else
                    {
                        aux.Modificado_Por = new Empleado() { Nombre = "Sistema" };
                    }

                    lista.Add(aux);
                }
            }
            catch (Exception ex) { throw ex; }
            finally { datos.CerrarConexion(); }

            return lista;
        }
    }
}