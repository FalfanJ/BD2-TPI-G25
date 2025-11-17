<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Presentacion.Login" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Login</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

</head>
<body class="bg-light">

    <form id="form1" runat="server">

        <div class="container d-flex justify-content-center align-items-center" style="height:100vh;">
            <div class="card shadow p-4" style="width: 350px; border-radius: 10px;">

                <h3 class="text-center mb-4">Iniciar Sesión</h3>

                <div class="mb-3">
                    <label class="form-label">Correo</label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Contraseña</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
                </div>

                <asp:Label ID="lblError" runat="server" CssClass="text-danger d-block mb-3" Visible="false"></asp:Label>

                <asp:Button ID="btnLogin" runat="server" Text="Ingresar"
                    CssClass="btn btn-primary w-100" OnClick="btnLogin_Click" />

            </div>
        </div>

    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

