#ifndef API_H
#define API_H

#include "avro.h"
#include "postgres_ext.h"

/* Parameters: context, wal_pos, xid */
typedef int (*begin_txn_cb)(void *, uint64_t, uint32_t);

/* Parameters: context, wal_pos, xid */
typedef int (*commit_txn_cb)(void *, uint64_t, uint32_t);

/* Parameters: context, wal_pos, relid,
 *             key_schema_json, key_schema_len, key_schema,
 *             row_schema_json, row_schema_len, row_schema */
typedef int (*table_schema_cb)(void *, uint64_t, Oid,
        const char *, size_t, avro_schema_t,
        const char *, size_t, avro_schema_t);

/* Parameters: context, wal_pos, relid,
 *             key_bin, key_len, key_val,
 *             new_bin, new_len, new_val */
typedef int (*insert_row_cb)(void *, uint64_t, Oid,
        const void *, size_t, avro_value_t *,
        const void *, size_t, avro_value_t *);

/* Parameters: context, wal_pos, relid,
 *             key_bin, key_len, key_val,
 *             old_bin, old_len, old_val,
 *             new_bin, new_len, new_val */
typedef int (*update_row_cb)(void *, uint64_t, Oid,
        const void *, size_t, avro_value_t *,
        const void *, size_t, avro_value_t *,
        const void *, size_t, avro_value_t *);

/* Parameters: context, wal_pos, relid,
 *             key_bin, key_len, key_val,
 *             old_bin, old_len, old_val */
typedef int (*delete_row_cb)(void *, uint64_t, Oid,
        const void *, size_t, avro_value_t *,
        const void *, size_t, avro_value_t *);

/* Parameters: context, message */
typedef int (*log_cb)(void *, char *);

/* See client/connect.h */
typedef struct client_context *client_context_t;

/* See client/protocol_client.h */
typedef struct frame_reader *frame_reader_t;


/* Allocate a new client context */
client_context_t bw_client_context_new(void);
/* Free a client context */
void bw_client_context_free(client_context_t context);

/* Set the callbacks */
void bw_set_begin_txn_callback(client_context_t client_context, begin_txn_cb callback);
void bw_set_on_commit_txn_callback(client_context_t client_context, commit_txn_cb callback);
void bw_set_on_table_schema_callback(client_context_t client_context, table_schema_cb callback);
void bw_set_on_insert_row_callback(client_context_t client_context, insert_row_cb callback);
void bw_set_on_update_row_callback(client_context_t client_context, update_row_cb callback);
void bw_set_on_delete_row_callback(client_context_t client_context, delete_row_cb callback);
void bw_set_on_log_callback(client_context_t client_context, log_cb callback);

/* Start the client */
int bw_run(client_context_t client_context);

/* Stop the client - not yet implemented */
/* int bw_stop(client_context_t client_context); */

#endif /* API_H */
