using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class TicketsNegocio
    {

        // METODO AGARRAR TICKET
        public void AgarrarTicket(int idTicket, int idTecnico)
        {
            AccesoDatos datosAsignar = new AccesoDatos();
            AccesoDatos datosEstado = new AccesoDatos();
            try
            {
                // --- PASO 1: Asignar el técnico usando TU SP ---
                datosAsignar.SetearProcedimiento("sp_AsignarTicket");
                datosAsignar.SetearParametro("@Id_Ticket", idTicket);
                datosAsignar.SetearParametro("@Id_Tecnico", idTecnico);
                datosAsignar.EjecutarAccion();

                // --- PASO 2: Cambiar estado y loguear ---
                int idEstadoEnProgreso = 2; // Asumimos ID 2 = "En Progreso"
                string comentario = "Ticket tomado por técnico.";

                datosEstado.SetearProcedimiento("sp_ActualizarEstadoTicket");
                datosEstado.SetearParametro("@Id_Ticket", idTicket);
                datosEstado.SetearParametro("@Id_NuevoEstado", idEstadoEnProgreso);
                datosEstado.SetearParametro("@Id_Tecnico", idTecnico);
                datosEstado.SetearParametro("@Descripcion", comentario);
                datosEstado.EjecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datosAsignar.CerrarConexion();
                datosEstado.CerrarConexion();
            }
        }

        // Método para actualizar el SLA
        public void ActualizarSLA(int idTicket, int idSLA)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearProcedimiento("sp_ActualizarSLA");
                datos.SetearParametro("@Id_Ticket", idTicket);
                datos.SetearParametro("@Id_SLA", idSLA);
                datos.EjecutarAccion();
            }
            catch (Exception ex) { throw ex; }
            finally { datos.CerrarConexion(); }
        }

        // Método para actualizar Estado y agregar Comentario
        public void ActualizarEstado(int idTicket, int idNuevoEstado, int idTecnico, string descripcion)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearProcedimiento("sp_ActualizarEstadoTicket");
                datos.SetearParametro("@Id_Ticket", idTicket);
                datos.SetearParametro("@Id_NuevoEstado", idNuevoEstado);
                datos.SetearParametro("@Id_Tecnico", idTecnico);
                datos.SetearParametro("@Descripcion", descripcion);
                datos.EjecutarAccion();
            }
            catch (Exception ex) { throw ex; }
            finally { datos.CerrarConexion(); }
        }

        // Método para obtener UN ticket (usando la vista)
        public Tickets ObtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
              
                string consulta = @"SELECT V.*, T.Descripcion, T.Id_EstadoTicket, T.Id_SLA 
                          FROM v_TicketsDetallados V
                          INNER JOIN Tickets T ON V.Id_Ticket = T.Id_Ticket
                          WHERE V.Id_Ticket = @id";

                datos.SetearConsulta(consulta);
                datos.SetearParametro("@id", id);
                datos.EjecutarLectura();

                if (datos.Lector.Read())
                {
                    Tickets ticket = new Tickets();
                    ticket.Id_Ticket = (int)datos.Lector["Id_Ticket"];
                    ticket.Titulos = (string)datos.Lector["Titulo"];
                    ticket.Fecha = (DateTime)datos.Lector["FechaCreacion"];

                    ticket.Cliente = new Empleado()
                    {
                        Id_Empleado = (int)datos.Lector["Id_Cliente"],
                        Nombre = (string)datos.Lector["Cliente"]
                    };

                    ticket.Equipo = new Equipo()
                    {
                        Id_Equipo = (int)datos.Lector["Id_Equipo"],
                        Nombre = (string)datos.Lector["NombreEquipo"]
                    };

                    ticket.EstadoTicket = new EstadosTicket()
                    {
                        NombreEstado = (string)datos.Lector["EstadoTicket"],
                        
                        Id_EstadoTicket = (int)datos.Lector["Id_EstadoTicket"]
                    };

                    if (!(datos.Lector["Descripcion"] is DBNull))
                        ticket.Descripcion = (string)datos.Lector["Descripcion"];

                    if (!(datos.Lector["Tecnico"] is DBNull))
                    {
                        ticket.Tecnico = new Empleado()
                        {
                            Id_Empleado = (int)datos.Lector["Id_Tecnico"],
                            Nombre = (string)datos.Lector["Tecnico"]
                        };
                    }


                    if (!(datos.Lector["Id_SLA"] is DBNull))
                    {
                        ticket.SLA = new SLA();
                        ticket.SLA.Id_SLA = (int)datos.Lector["Id_SLA"];
                    
                        if (!(datos.Lector["NivelSLA"] is DBNull))
                        {
                            ticket.SLA.Nivel = (string)datos.Lector["NivelSLA"];
                        }
                    }

                    return ticket;
                }
                return null;
            }
            catch (Exception ex) { throw ex; }
            finally { datos.CerrarConexion(); }
        }
        // MÉTODO PARA EL PANEL DEL CLIENTE
        public List<Tickets> ListarMisTickets(int idCliente)
        {
            List<Tickets> lista = new List<Tickets>();
            AccesoDatos datos = new AccesoDatos();

            try
            {

                // Consultamos la VISTA, no la tabla
                string consulta = @"SELECT Id_Ticket, Titulo, FechaCreacion, EstadoTicket, Tecnico 
                                  FROM v_TicketsDetallados 
                                  WHERE Id_Cliente = @idCliente 
                                  ORDER BY FechaCreacion DESC";

                datos.SetearConsulta(consulta);
                datos.SetearParametro("@idCliente", idCliente);
                datos.EjecutarLectura();

                while (datos.Lector.Read())
                {
                    Tickets aux = new Tickets();
                    aux.Id_Ticket = (int)datos.Lector["Id_Ticket"];
                    aux.Titulos = (string)datos.Lector["Titulo"];
                    aux.Fecha = (DateTime)datos.Lector["FechaCreacion"];

                    // Ya traemos el nombre del estado!
                    aux.EstadoTicket = new EstadosTicket();
                    aux.EstadoTicket.NombreEstado = (string)datos.Lector["EstadoTicket"];

                    // Manejamos el TÉCNICO (que puede ser NULL)
                    if (!(datos.Lector["Tecnico"] is DBNull))
                    {
                        aux.Tecnico = new Empleado();
                        aux.Tecnico.Nombre = (string)datos.Lector["Tecnico"];
                    }

                    lista.Add(aux);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        // -- MÉTODOS PARA AGREGAR UN NUEVO TICKET --

        public void Agregar(Tickets nuevoTicket)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Usamos el SP que ya tenés en tu DB
                datos.SetearProcedimiento("sp_CrearTicket");

                datos.SetearParametro("@Id_Cliente", nuevoTicket.Cliente.Id_Empleado);
                datos.SetearParametro("@Id_Equipo", nuevoTicket.Equipo.Id_Equipo);
                datos.SetearParametro("@Titulos", nuevoTicket.Titulos);
                datos.SetearParametro("@Id_TipoTicket", nuevoTicket.TipoTicket.Id_TipoTicket);
                datos.SetearParametro("@Descripcion", nuevoTicket.Descripcion);

                // Ejecutamos la acción (INSERT)
                datos.EjecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        // --- MÉTODOS PARA EL PANEL DEL TÉCNICO ---

        // Para la pestaña "Mis Tickets Asignados"
        public List<Tickets> ListarMisTicketsAsignados(int idTecnico)
        {
            List<Tickets> lista = new List<Tickets>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"SELECT Id_Ticket, Titulo, Cliente, EstadoTicket, NivelSLA 
                                  FROM v_TicketsDetallados 
                                  WHERE Id_Tecnico = @idTecnico 
                                  ORDER BY FechaCreacion ASC";

                datos.SetearConsulta(consulta);
                datos.SetearParametro("@idTecnico", idTecnico);
                datos.EjecutarLectura();

                while (datos.Lector.Read())
                {
                    Tickets aux = new Tickets();
                    aux.Id_Ticket = (int)datos.Lector["Id_Ticket"];
                    aux.Titulos = (string)datos.Lector["Titulo"];

                    aux.Cliente = new Empleado();
                    aux.Cliente.Nombre = (string)datos.Lector["Cliente"];

                    aux.EstadoTicket = new EstadosTicket();
                    aux.EstadoTicket.NombreEstado = (string)datos.Lector["EstadoTicket"];

                    if (!(datos.Lector["NivelSLA"] is DBNull))
                    {
                        aux.SLA = new SLA();
                        aux.SLA.Nivel = (string)datos.Lector["NivelSLA"];
                    }
                    lista.Add(aux);
                }
                return lista;
            }
            catch (Exception ex) { throw ex; }
            finally { datos.CerrarConexion(); }
        }

        // Para la pestaña "Tickets Sin Asignar"
        public List<Tickets> ListarTicketsSinAsignar()
        {
            List<Tickets> lista = new List<Tickets>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Usamos la VISTA v_TicketsDetallados
                string consulta = @"SELECT Id_Ticket, Titulo, Cliente, FechaCreacion 
                                  FROM v_TicketsDetallados 
                                  WHERE Id_Tecnico IS NULL AND Id_GrupoAsignado IS NULL 
                                  ORDER BY FechaCreacion ASC";

                datos.SetearConsulta(consulta);
                datos.EjecutarLectura();

                while (datos.Lector.Read())
                {
                    Tickets aux = new Tickets();
                    aux.Id_Ticket = (int)datos.Lector["Id_Ticket"];
                    aux.Titulos = (string)datos.Lector["Titulo"];
                    aux.Fecha = (DateTime)datos.Lector["FechaCreacion"];

                    aux.Cliente = new Empleado();
                    aux.Cliente.Nombre = (string)datos.Lector["Cliente"];

                    lista.Add(aux);
                }
                return lista;
            }
            catch (Exception ex) { throw ex; }
            finally { datos.CerrarConexion(); }
        }
    }
}