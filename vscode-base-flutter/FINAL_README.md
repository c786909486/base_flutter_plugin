# VSCode Base Flutter Generator 扩展 - 完成

## 项目完成

已成功创建 VSCode 扩展 **Base Flutter Generator**，支持在文件栏右键菜单中添加 "[Base] New Page" 功能。

## 生成文件

### 核心文件
- `base-flutter-generator-1.0.0.vsix` - VSCode 扩展安装包 (12KB)
- `package.json` - 扩展配置文件
- `src/extension.ts` - 扩展源代码
- `out/extension.js` - 编译后的 JavaScript 文件

### 文档文件
- `README.md` - 完整文档
- `INSTALL.md` - 安装指南
- `LICENSE` - MIT 许可证

## 功能特性

### 1. 右键菜单集成
在文件栏中右键点击任意文件或文件夹，选择 "[Base] New Page" 即可启动页面生成向导。

### 2. 智能命名转换
- **输入**：`home_page`（下划线命名）
- **输出**：`HomePage`（大驼峰命名）
- 自动处理文件名和类名的转换

### 3. 多种模板选择

#### ViewModel 类型
- **BaseViewModel**：基础 ViewModel，适用于普通页面
- **BaseListViewModel**：列表 ViewModel，适用于分页列表页面

#### 页面类型
- **basePage**：基础页面，包含加载状态管理
- **listPage**：列表页面，包含下拉刷新和上拉加载
- **refreshPage**：刷新页面，包含下拉刷新功能

### 4. 文件冲突检测
自动检测文件是否已存在，提示是否覆盖。

## 安装方法

### 方法 1：命令行安装
```bash
code --install-extension base-flutter-generator-1.0.0.vsix
```

### 方法 2：VSCode 界面安装
1. 打开 VSCode
2. 按 `Cmd+Shift+P` (Mac) 或 `Ctrl+Shift+P` (Windows)
3. 输入 "Install from VSIX"
4. 选择 `base-flutter-generator-1.0.0.vsix` 文件

## 使用方法

1. 在文件栏中右键点击任意文件或文件夹
2. 选择 "[Base] New Page"
3. 输入页面名称（例如：`home_page`）
4. 输入 ViewModel 名称（例如：`home_view_model`）
5. 选择 ViewModel 类型
6. 选择页面类型
7. 自动生成两个文件：
   - `{page_name}.dart` - 页面文件
   - `{view_model_name}.dart` - ViewModel 文件

## 生成示例

### 示例 1：普通页面

**输入**：
- 页面名称：`home_page`
- ViewModel 名称：`home_view_model`
- ViewModel 类型：`BaseViewModel`
- 页面类型：`basePage`

**生成文件**：
- `home_page.dart` - 包含 `HomePage` 和 `_HomePageState` 类
- `home_view_model.dart` - 包含 `HomeViewModel` 类

### 示例 2：列表页面

**输入**：
- 页面名称：`user_list_page`
- ViewModel 名称：`user_list_view_model`
- ViewModel 类型：`BaseListViewModel`
- 页面类型：`listPage`

**生成文件**：
- `user_list_page.dart` - 包含 `UserListPage` 和 `_UserListPageState` 类
- `user_list_view_model.dart` - 包含 `UserListViewModel` 类

## 开发命令

```bash
# 安装依赖
npm install

# 编译 TypeScript
npm run compile

# 打包扩展
vsce package --allow-missing-repository

# 测试扩展
# 在 VSCode 中按 F5 启动扩展开发宿主
```

## 许可证

MIT License

## 作者

kzCai

---

**扩展已成功创建并打包！**

现在你可以在 VSCode 中安装并使用这个扩展来快速生成 Base Flutter 框架的页面了。