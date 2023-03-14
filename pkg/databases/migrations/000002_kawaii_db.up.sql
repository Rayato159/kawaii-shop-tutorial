BEGIN;

INSERT INTO "roles" (
    "title"
)
VALUES
    ('customer'),
    ('admin');

INSERT INTO "users" (
    "username",
    "email",
    "password",
    "role_id"
)
VALUES
    ('customer001', 'customer001@kawaii.com', '$2a$10$8KzaNdKIMyOkASCH4QvSKuEMIY7Jc3vcHDuSJvXLii1rvBNgz60a6', 1),
    ('admin001', 'admin001@kawaii.com', '$2a$10$3qqNPE.TJpNGYCohjTgw9.v1z0ckovx95AmiEtUXcixGAgfW7.wCi', 2);


INSERT INTO "categories"
    (
        "title"
    )
VALUES
    ('food & beverage'),
    ('fashion'),
    ('gadget');

INSERT INTO "products"
    (
        "title",
        "description",
        "price"
    )
VALUES
    ('Coffee', 'Just a food & beverage product', 150),
    ('Steak', 'Just a food & beverage product', 200),
    ('Shirt', 'Just a fashion product', 590),
    ('Touser', 'Just a fashion product', 1490),
    ('Phone', 'Just a gadget product', 33400),
    ('Computer', 'Just a gadget product', 49000);

INSERT INTO "images"
    (
        "id",
        "filename",
        "url",
        "product_id"
    )

VALUES
    ('c580fe73-afb3-47d1-a9df-eed24fdaea9b', 'fb1_1.jpg', 'https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg', 'P000001'),
    ('43bcd3fa-6f7f-4251-b196-f30ad4ea625e', 'fb1_2.jpg', 'https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg', 'P000001'),
    ('77d9e690-b722-4039-b0fe-5f7d9af0e6b4', 'fb1_3.jpg', 'https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg', 'P000001'),
    ('1d1eed38-3568-4e3e-9322-4c902b94c5b8', 'fb2_1.jpg', 'https://i.pinimg.com/564x/6d/ba/91/6dba91c1fdb5d4939c7e9d65420cbd4c.jpg', 'P000002'),
    ('f56c212a-16fd-4f8a-9091-03d2943c7f22', 'fb2_2.jpg', 'https://i.pinimg.com/564x/6d/ba/91/6dba91c1fdb5d4939c7e9d65420cbd4c.jpg', 'P000002'),
    ('6dfe9af7-1c48-4280-9805-60e7342ce2f7', 'fb2_3.jpg', 'https://i.pinimg.com/564x/6d/ba/91/6dba91c1fdb5d4939c7e9d65420cbd4c.jpg', 'P000002'),
    ('db2c59f0-434e-46b6-8184-e90c4bd15c3a', 'fs1_1.jpg', 'https://i.pinimg.com/564x/a0/6b/70/a06b708becbefa5d642392d7bf805429.jpg', 'P000003'),
    ('4f1823d4-66e1-46de-bb15-8f56804bd810', 'fs1_2.jpg', 'https://i.pinimg.com/564x/a0/6b/70/a06b708becbefa5d642392d7bf805429.jpg', 'P000003'),
    ('bdf45efe-6b87-4ae8-9695-9a356844494c', 'fs1_3.jpg', 'https://i.pinimg.com/564x/a0/6b/70/a06b708becbefa5d642392d7bf805429.jpg', 'P000003'),
    ('251b8707-6a18-4cf9-b298-fec2a06586ca', 'fs2_1.jpg', 'https://i.pinimg.com/564x/e8/0a/0c/e80a0c4f562a942c01f6060a1e375a0b.jpg', 'P000004'),
    ('cadf3ebc-a1aa-4dc7-ab40-7e32d68ce4bc', 'fs2_2.jpg', 'https://i.pinimg.com/564x/e8/0a/0c/e80a0c4f562a942c01f6060a1e375a0b.jpg', 'P000004'),
    ('1e9bf281-76cf-4fc6-ba3b-22a66d9353b9', 'fs2_3.jpg', 'https://i.pinimg.com/564x/e8/0a/0c/e80a0c4f562a942c01f6060a1e375a0b.jpg', 'P000004'),
    ('e4c8ee7b-7c67-4d92-9955-d79f151bd40c', 'gt1_1.jpg', 'https://i.pinimg.com/564x/d5/95/e4/d595e4530aaa0fcdf4ff8e7bc17f4d86.jpg', 'P000005'),
    ('efae60af-94a5-4c2d-bb83-d3c5500c3c2e', 'gt1_2.jpg', 'https://i.pinimg.com/564x/d5/95/e4/d595e4530aaa0fcdf4ff8e7bc17f4d86.jpg', 'P000005'),
    ('1b4e1ec5-034a-441b-adcb-0da747ff49ef', 'gt1_3.jpg', 'https://i.pinimg.com/564x/d5/95/e4/d595e4530aaa0fcdf4ff8e7bc17f4d86.jpg', 'P000005'),
    ('df4912fc-c29b-48f1-a482-eaed6fb8f823', 'gt2_1.jpg', 'https://i.pinimg.com/564x/10/51/07/105107b2456059018b668f8d3e3989f6.jpg', 'P000006'),
    ('19d07a1f-342e-475d-8983-4a5ddc586ef1', 'gt2_2.jpg', 'https://i.pinimg.com/564x/10/51/07/105107b2456059018b668f8d3e3989f6.jpg', 'P000006'),
    ('dd65d3b2-3b50-49e3-9506-be66ef36810d', 'gt2_3.jpg', 'https://i.pinimg.com/564x/10/51/07/105107b2456059018b668f8d3e3989f6.jpg', 'P000006');

INSERT INTO "products_categories"
    (
        "product_id",
        "category_id"
    )
VALUES
    ('P000001', 1),
    ('P000002', 1),
    ('P000003', 2),
    ('P000004', 2),
    ('P000005', 3),
    ('P000006', 3);

INSERT INTO "orders"
    (
        "user_id",
        "contact",
        "address",
        "transfer_slip",
        "status"
    )
VALUES
    ('U000002', 'kawaii customer', '(330) 546-7713 5180 Richville Dr SW Navarre, Ohio(OH), 44662', '{"id":"4bd7a0f5-c41f-4c1a-a997-0d965352fbb2","filename":"slip.jpg","url":"https://i.pinimg.com/564x/a8/d4/f5/a8d4f5a620d22128c2b6d1a42c847560.jpg","created_at":"2023-03-01 23:21:00"}'::jsonb, 'completed'),
    ('U000002', 'kawaii customer', '(410) 256-8192 2260 Brimstone Pl Hanover, Maryland(MD), 21076', NULL, 'waiting');

INSERT INTO "products_orders"
    (
        "order_id",
        "qty",
        "product"
    )
VALUES
    ('O000001', 1, '{"id":"P000001","title":"Coffee", "price":150, "description":"Just a food & beverage product","category":{"id":1,"title":"food & beverage"},"created_at":"2023-03-10T00:03:59.677167","updated_at":"2023-03-10T00:03:59.677167","images":[{"id":"c580fe73-afb3-47d1-a9df-eed24fdaea9b","filename":"fb1_1.jpg","url":"https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg"},{"id":"43bcd3fa-6f7f-4251-b196-f30ad4ea625e","filename":"fb1_2.jpg","url":"https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg"},{"id":"77d9e690-b722-4039-b0fe-5f7d9af0e6b4","filename":"fb1_3.jpg","url":"https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg"}]}'::jsonb),
    ('O000001', 2, '{"id":"P000002","title":"Steak", "price":200, "description":"Just a food & beverage product","category":{"id":1,"title":"food & beverage"},"created_at":"2023-03-10T00:03:59.677167","updated_at":"2023-03-10T00:03:59.677167","images":[{"id":"1d1eed38-3568-4e3e-9322-4c902b94c5b8","filename":"fb2_1.jpg","url":"https://i.pinimg.com/564x/6d/ba/91/6dba91c1fdb5d4939c7e9d65420cbd4c.jpg"},{"id":"f56c212a-16fd-4f8a-9091-03d2943c7f22","filename":"fb2_2.jpg","url":"https://i.pinimg.com/564x/6d/ba/91/6dba91c1fdb5d4939c7e9d65420cbd4c.jpg"},{"id":"6dfe9af7-1c48-4280-9805-60e7342ce2f7","filename":"fb2_3.jpg","url":"https://i.pinimg.com/564x/6d/ba/91/6dba91c1fdb5d4939c7e9d65420cbd4c.jpg"}]}'::jsonb),
    ('O000002', 1, '{"id":"P000001","title":"Coffee", "price":150, "description":"Just a food & beverage product","category":{"id":1,"title":"food & beverage"},"created_at":"2023-03-10T00:03:59.677167","updated_at":"2023-03-10T00:03:59.677167","images":[{"id":"c580fe73-afb3-47d1-a9df-eed24fdaea9b","filename":"fb1_1.jpg","url":"https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg"},{"id":"43bcd3fa-6f7f-4251-b196-f30ad4ea625e","filename":"fb1_2.jpg","url":"https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg"},{"id":"77d9e690-b722-4039-b0fe-5f7d9af0e6b4","filename":"fb1_3.jpg","url":"https://i.pinimg.com/564x/4a/1c/4a/4a1c4a9755e4d3bdfcb45a1c3a58712f.jpg"}]}'::jsonb),
    ('O000002', 1, '{"id":"P000002","title":"Steak", "price":200, "description":"Just a food & beverage product","category":{"id":1,"title":"food & beverage"},"created_at":"2023-03-10T00:03:59.677167","updated_at":"2023-03-10T00:03:59.677167","images":[{"id":"1d1eed38-3568-4e3e-9322-4c902b94c5b8","filename":"fb2_1.jpg","url":"https://i.pinimg.com/564x/6d/ba/91/6dba91c1fdb5d4939c7e9d65420cbd4c.jpg"},{"id":"f56c212a-16fd-4f8a-9091-03d2943c7f22","filename":"fb2_2.jpg","url":"https://i.pinimg.com/564x/6d/ba/91/6dba91c1fdb5d4939c7e9d65420cbd4c.jpg"},{"id":"6dfe9af7-1c48-4280-9805-60e7342ce2f7","filename":"fb2_3.jpg","url":"https://i.pinimg.com/564x/6d/ba/91/6dba91c1fdb5d4939c7e9d65420cbd4c.jpg"}]}'::jsonb);

COMMIT;