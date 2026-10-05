import {pgTable, uuid, varchar, text, timestamp} from 'drizzle-orm/pg-core';

export const userTable = pgTable('users', {
    id: uuid('id').primaryKey().defaultRandom(),

    name: varchar('name', {length: 50}).notNull(),

    email: varchar('email', {length: 322}),
    password: varchar('password', {length: 66}),

    salt: text('salt'),

    createdAt: timestamp('created_at').defaultNow().notNull(),
    updatedAt: timestamp('updated_at').$onUpdate(() => new Date()),
});