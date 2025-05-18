require("dotenv").config();
const express = require("express");
const cors = require("cors");
const jwt = require("jsonwebtoken");
const bodyParser = require("body-parser");


const app = express();
const PORT = 5000;
const SECRET_KEY = "your_secret_key"; // Thay bằng một chuỗi bí mật mạnh

app.use(cors());
app.use(bodyParser.json());
app.use(express.json());
// Giả lập danh sách tài khoản trong DB
const users = [
<<<<<<< Updated upstream
    { id: 1, username: "admin", password: "123456" },
    { id: 2, username: "user", password: "123" },
];

// API đăng nhập
=======
    {
        id: 0,
        username: "admin",
        password: "123456",
        role: "admin",
    },
    {
        id: 1,
        username: "user1",
        password: "123",
        role: "user",
        isDeleted: false,
        
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
        username: "user2",
        password: "1234",
        role: "user",
        isDeleted: false,
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


//lấy thông tin người dùng hiện tại
app.get("/user/me", authenticateToken, (req, res) => {
    const user = findUserById(req.user.userId);
    if (!user) {
        return res.status(404).json({ message: "User not found" });
    }
    res.json({ username: user.username, role: user.role });
});

// Đăng nhập
>>>>>>> Stashed changes
app.post("/login", (req, res) => {
    console.log(req.body); 
    const { username, password } = req.body;
    const user = users.find(
        (u) => u.username === username && u.password === password
    );

    if (!user) {
        return res.status(401).json({ message: "Sai tài khoản hoặc mật khẩu" });
    }

<<<<<<< Updated upstream
    // Tạo token JWT
    const token = jwt.sign({ userId: user.id, username: user.username }, SECRET_KEY, {
=======
    const token = jwt.sign({ userId: user.id, username: user.username, role: user.role || 'user' }, SECRET_KEY, {
>>>>>>> Stashed changes
        expiresIn: "1h",
    });

    res.json({ token });
});

<<<<<<< Updated upstream
// API kiểm tra token (ví dụ lấy thông tin user)
app.get("/profile", (req, res) => {
=======
// Middleware kiểm tra quyền admin
function requireAdmin(req, res, next) {
    const user = findUserById(req.user.userId);
    if (!user || user.role !== 'admin') {
        return res.status(403).json({ message: "Bạn không có quyền admin" });
    }
    next();
}

app.get("/admin/users", authenticateToken, requireAdmin, (req, res) => {
    const result = users.map(u => ({
        id: u.id,
        username: u.username,
        role: u.role || 'user',
        isDeleted: u.isDeleted || false,
    }));
    res.json(result);
});


//Xóa tài khoản (chỉ admin)
app.delete("/admin/users/:id", authenticateToken, requireAdmin, (req, res) => {
    const userId = parseInt(req.params.id);
    const user = users.find(u => u.id === userId);

    if (!user) {
        return res.status(404).json({ message: "User không tồn tại" });
    }

    if (user.role === "admin") {
        return res.status(403).json({ message: "Không thể xóa admin" });
    }

    user.isDeleted = true;
    res.json({ message: "Đã đánh dấu user là đã xoá" });
});



//Khoi phuc tai khoan
app.patch("/admin/users/restore/:id", authenticateToken, requireAdmin, (req, res) => {
    const userId = parseInt(req.params.id);
    const user = users.find(u => u.id === userId);

    if (!user) {
        return res.status(404).json({ message: "User không tồn tại" });
    }

    user.isDeleted = false;
    res.json({ message: "Khôi phục tài khoản thành công" });
});



//Tạo tài khoản mới (chỉ admin)
app.post("/admin/users", authenticateToken, requireAdmin, (req, res) => {
    const { username, password, role = "user" } = req.body;

    if (users.some(u => u.username === username)) {
        return res.status(400).json({ message: "Username đã tồn tại" });
    }

    const newUser = {
        id: Date.now(),
        username,
        password,
        role,
        shoppingLists: [],
        sharedWith: [],
    };
    users.push(newUser);
    res.status(201).json({ message: "Tạo tài khoản thành công", user: newUser });
});

// Middleware xác thực token
function authenticateToken(req, res, next) {
>>>>>>> Stashed changes
    const token = req.headers.authorization?.split(" ")[1];

    if (!token) {
        return res.status(401).json({ message: "Không có token" });
    }

    try {
        const decoded = jwt.verify(token, SECRET_KEY);
        res.json({ user: decoded });
    } catch (error) {
        res.status(401).json({ message: "Token không hợp lệ" });
    }
<<<<<<< Updated upstream
=======
}

// Lấy danh sách giỏ hàng cá nhân và được chia sẻ
app.get("/shopping-lists", authenticateToken, (req, res) => {
    const user = findUserById(req.user.userId);
    const sharedLists = users
        .filter(u => Array.isArray(u.sharedWith) && u.sharedWith.includes(user.id))
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
>>>>>>> Stashed changes
});

// Chạy server
app.listen(PORT, () => {
    console.log(`Server đang chạy tại http://localhost:${PORT}`);
});
