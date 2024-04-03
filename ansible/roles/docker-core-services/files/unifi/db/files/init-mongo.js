db.getSiblingDB('unifidb').createUser({
  user: 'unifi',
  pwd: 'unifi',
  roles: [{ role: 'dbOwner', db: 'unifidb' }],
})
db.getSiblingDB('unifidb_stat').createUser({
  user: 'unifi',
  pwd: 'unifi',
  roles: [{ role: 'dbOwner', db: 'unifidb_stat' }],
})
