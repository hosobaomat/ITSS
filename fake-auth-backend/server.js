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
    { id: 1, username: "admin", password: "123456" },
    { id: 2, username: "user", password: "123" },
];

// API đăng nhập
app.post("/login", (req, res) => {
    console.log(req.body); 
    const { username, password } = req.body;
    const user = users.find(
        (u) => u.username === username && u.password === password
    );

    if (!user) {
        return res.status(401).json({ message: "Sai tài khoản hoặc mật khẩu" });
    }

    // Tạo token JWT
    const token = jwt.sign({ userId: user.id, username: user.username }, SECRET_KEY, {
        expiresIn: "1h",
    });

    res.json({ token });
});

// API kiểm tra token (ví dụ lấy thông tin user)
app.get("/profile", (req, res) => {
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
});

// Chạy server
app.listen(PORT, () => {
    console.log(`Server đang chạy tại http://localhost:${PORT}`);
});
