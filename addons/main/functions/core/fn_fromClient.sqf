// -> bool (servidor): el código actual llega por remoteExec desde un cliente que no es el propio servidor/anfitrión
isMultiplayer && {!(remoteExecutedOwner in [0, clientOwner])}
