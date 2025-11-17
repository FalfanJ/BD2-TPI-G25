--TRIGGERS
USE BD2_TPI_G25
GO

-- TRIGGER AUDITAR TICKET

CREATE TRIGGER dbo.tr_AuditarTickets
ON dbo.Tickets
AFTER INSERT 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Id_Ticket INT
    DECLARE @Id_Estado INT
    DECLARE @Modificado_Por INT
    DECLARE @Descripcion VARCHAR(MAX) 

    --Creación de un nuevo ticket 
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT 
            @Id_Ticket = i.Id_Ticket,
            @Id_Estado = i.Id_EstadoTicket,
            @Modificado_Por = i.Id_Cliente,
            @Descripcion = i.Descripcion 
        FROM inserted i;

        INSERT INTO dbo.HistorialTickets (
            Id_Ticket, FechaModificacion, Modificado_Por, Id_Estado, Descripcion
        )
        VALUES (
            @Id_Ticket, GETDATE(), @Modificado_Por, @Id_Estado, @Descripcion
        );
    END
END
GO


--tr_EvitarBorradoEmpleadoActivo 

CREATE TRIGGER tr_EvitarBorradoEmpleadoActivo
ON Empleado
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM Tickets T
        INNER JOIN deleted D ON T.Id_Tecnico = D.Id_Empleado
    )
    BEGIN
        RAISERROR ('No se puede eliminar un empleado activo: esta asignado como tecnico en uno o mas tickets.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM Tickets T
        INNER JOIN deleted D ON T.Id_Cliente = D.Id_Empleado
    )
    BEGIN
        RAISERROR ('No se puede eliminar un empleado activo: esta asignado como cliente en uno o mas tickets.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM EmpleadosGrupos EG
        INNER JOIN deleted D ON EG.Id_Empleado = D.Id_Empleado
    )
    BEGIN
        RAISERROR ('No se puede eliminar un empleado activo: pertenece a un grupo de soporte.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DELETE E
    FROM Empleado E
    INNER JOIN deleted D ON E.Id_Empleado = D.Id_Empleado;

END
GO

-- tr_EvitarBorradoEquipoAsignado 

CREATE TRIGGER tr_EvitarBorradoEquipoAsignado
ON Equipo
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @id_equipo INTEGER
    SELECT @id_equipo = Id_Equipo FROM deleted
    
    IF EXISTS(
        SELECT * FROM EquipoEmpleado WHERE Id_Equipo = @id_equipo
    )
    BEGIN
        RAISERROR('No se puede eliminar equipo asignado a empleado activo.',16,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    DELETE FROM Equipo WHERE Id_Equipo = @id_equipo
END
GO