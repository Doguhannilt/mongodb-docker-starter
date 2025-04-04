db = db.getSiblingDB("key-value-db");

db.createUser({
    user: "key-value-user",
    pwd: "key-value-password",
    roles: [{ role: "readWrite", db: "key-value-db" }]
});
