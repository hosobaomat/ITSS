// server.js
require("dotenv").config();
const express = require("express");
const cors = require("cors");
const jwt = require("jsonwebtoken");
const bodyParser = require("body-parser");

const app = express();
const PORT = 5000;
const SECRET_KEY = "your_secret_key";

app.use(cors());
app.use(bodyParser.json());
app.use(express.json());

// Cơ sở dữ liệu giả
const users = [
    {
        id: 1,
        username: "admin",
        password: "123456",
        shoppingLists: [
            {
                id: 1697059100000,
                title: "Admin's Weekend Shopping",
                date: "2025-05-09T15:30:00.000Z",
                items: [
                    { name: "Milk", icon: "local_drink", isDone: false },
                    { name: "Eggs", icon: "egg", isDone: false }
                ]
            },
            {
                id: 1697059000000,
                title: "Admin's Party Supplies",
                date: "2025-05-11T12:00:00.000Z",
                items: [
                    { name: "Chips", icon: "shopping_cart", isDone: true },
                    { name: "Soda", icon: "local_drink", isDone: false }
                ]
            }
        ],
        sharedWith: [2], // Danh sách userId mà admin chia sẻ giỏ hàng với
    },
    {
        id: 2,
        username: "user",
        password: "123",
        shoppingLists: [
            {
                id: 1697059200000,
                title: "User's Weekly Grocery",
                date: "2025-05-10T10:00:00.000Z",
                items: [
                    { name: "Bread", icon: "local_drink", isDone: false },
                    { name: "Butter", icon: "restaurant", isDone: true }
                ]
            }
        ],
        sharedWith: [1],
    },
];

// Helper tìm user theo ID
function findUserById(id) {
    return users.find((u) => u.id === id);
}

// Đăng nhập
app.post("/login", (req, res) => {
    const { username, password } = req.body;
    const user = users.find(
        (u) => u.username === username && u.password === password
    );

    if (!user) {
        return res.status(401).json({ message: "Sai tài khoản hoặc mật khẩu" });
    }

    const token = jwt.sign({ userId: user.id, username: user.username }, SECRET_KEY, {
        expiresIn: "1h",
    });

    res.json({ token });
});

// Middleware xác thực token
function authenticateToken(req, res, next) {
    const token = req.headers.authorization?.split(" ")[1];

    if (!token) {
        return res.status(401).json({ message: "Không có token" });
    }

    try {
        const decoded = jwt.verify(token, SECRET_KEY);
        req.user = decoded;
        next();
    } catch (error) {
        res.status(401).json({ message: "Token không hợp lệ" });
    }
}

// Lấy danh sách giỏ hàng cá nhân và được chia sẻ
app.get("/shopping-lists", authenticateToken, (req, res) => {
    const user = findUserById(req.user.userId);
    const sharedLists = users
        .filter(u => u.sharedWith.includes(user.id))
        .flatMap(u => u.shoppingLists.map(list => ({ ...list, sharedBy: u.username })));

    res.json({
        personal: user.shoppingLists,
        shared: sharedLists,
    });
});

// Thêm giỏ hàng mới
app.post("/shopping-lists", authenticateToken, (req, res) => {
    const user = findUserById(req.user.userId);
    const newList = {
        id: Date.now(),
        title: req.body.title,
        date: new Date().toISOString(),
        items: req.body.items || [],
    };
    user.shoppingLists.push(newList);
    res.status(201).json(newList);
});

// Chia sẻ giỏ hàng cho user khác
app.post("/share", authenticateToken, (req, res) => {
    const { toUserId } = req.body;
    const user = findUserById(req.user.userId);
    const targetUser = findUserById(toUserId);

    if (!targetUser) {
        return res.status(404).json({ message: "User không tồn tại" });
    }

    if (!user.sharedWith.includes(toUserId)) {
        user.sharedWith.push(toUserId);
    }

    res.json({ message: `Đã chia sẻ danh sách với ${targetUser.username}` });
});

app.listen(PORT, () => {
    console.log(`Server đang chạy tại http://localhost:${PORT}`);
});
