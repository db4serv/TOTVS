db.createUser(
    {
    user: "admin",
    pwd: "#Dbasql67!",
    roles: [ "userAdminAnyDatabase",
             "dbAdminAnyDatabase",
             "readWriteAnyDatabase"]
    }
   )