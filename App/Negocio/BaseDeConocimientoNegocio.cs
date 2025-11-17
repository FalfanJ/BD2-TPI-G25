using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class BaseDeConocimientoNegocio
    {

        public BaseDeConocimiento ObtenerPorId(long idArticulo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"SELECT Id_Articulo, Titulo, Solucion, 
                                   NombreAutor, ApellidoAutor, CorreoAutor
                            FROM v_BaseConocimientoAutores 
                            WHERE Id_Articulo = @id";

                datos.SetearConsulta(consulta);
                datos.SetearParametro("@id", idArticulo);
                datos.EjecutarLectura();

                if (datos.Lector.Read())
                {
                    BaseDeConocimiento aux = new BaseDeConocimiento();
                    aux.Id_Articulo = (long)datos.Lector["Id_Articulo"];
                    aux.Titulo = (string)datos.Lector["Titulo"];
                    aux.Solucion = (string)datos.Lector["Solucion"];

                    aux.Autor = new Empleado();
                    aux.Autor.Nombre = (string)datos.Lector["NombreAutor"];
                    aux.Autor.Apellido = (string)datos.Lector["ApellidoAutor"];
                    aux.Autor.Correo = (string)datos.Lector["CorreoAutor"];

                    return aux;
                }
                return null; 
            }
            catch (Exception ex) { throw ex; }
            finally { datos.CerrarConexion(); }
        }
        public void Agregar(BaseDeConocimiento nuevoArticulo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearProcedimiento("SP_CrearArticuloConocimiento");

                datos.SetearParametro("@Titulo", nuevoArticulo.Titulo);
                datos.SetearParametro("@Solucion", nuevoArticulo.Solucion);
                datos.SetearParametro("@Id_Autor", nuevoArticulo.Autor.Id_Empleado);

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

        // Método actualizado para usar la vista
        public List<BaseDeConocimiento> Listar()
        {
            List<BaseDeConocimiento> lista = new List<BaseDeConocimiento>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                // 1. Consultamos la VISTA, no la tabla
                datos.SetearConsulta(@"SELECT Id_Articulo, Titulo, Solucion, 
                                            NombreAutor, ApellidoAutor, CorreoAutor
                                      FROM v_BaseConocimientoAutores");

                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    BaseDeConocimiento aux = new BaseDeConocimiento();
                    aux.Id_Articulo = (long)datos.Lector["Id_Articulo"];
                    aux.Titulo = (string)datos.Lector["Titulo"];
                    aux.Solucion = (string)datos.Lector["Solucion"];

                    // 2. Cargamos el objeto Autor con los datos ya unidos por la vista
                    aux.Autor = new Empleado();
                    aux.Autor.Nombre = (string)datos.Lector["NombreAutor"];
                    aux.Autor.Apellido = (string)datos.Lector["ApellidoAutor"];
                    aux.Autor.Correo = (string)datos.Lector["CorreoAutor"];

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
    }
}