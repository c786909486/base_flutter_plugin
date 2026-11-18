# flutter-base-framework（DSH Skill）

从本仓库 `base_flutter` 基础框架沉淀出的页面创建技能：让 AI Agent 在依赖
`base_flutter` 的 Flutter 工程中，按统一 MVVM 约定创建

1. 基础内容页（`BaseMvvmState` + `BaseViewModel`）
2. 列表页（`BaseMvvmListState` + `BaseListViewModel`，下拉刷新 + 上拉加载）
3. 可刷新的滑动页面（`BaseMvvmRefreshState` + `BaseListViewModel`）

并附带新工程接入、路由传参、生命周期、加载/空/错误态约定与验证清单。

## 目录结构

```text
.dsh/skills/flutter-base-framework/
├── SKILL.md                          # 技能主文件（DSH 只扫描这一层）
├── README.md                         # 本文件：安装说明
└── references/
    ├── api-cheatsheet.md             # 基类/方法/字段签名速查
    └── templates/
        ├── app_entry.dart            # App 入口（navigatorKey + observer）
        ├── basic_page.dart           # 基础内容页模板
        ├── list_page.dart            # 列表页模板
        └── refresh_page.dart         # 可刷新滑动页面模板
```

## DSH 安装位置

DSH 按以下约定扫描技能（`<name>/SKILL.md`，技能名必须是 kebab-case）：

| 作用域 | 目录 |
| --- | --- |
| 项目技能 | `<项目根>/.dsh/skills/` |
| 项目技能（agents 约定） | `<项目根>/.agents/skills/` |
| 用户技能（全局） | `~/.dsh/skills/` |
| 用户技能（agents 约定） | `~/.agents/skills/` |

本技能安装为**用户级（全局）技能**：`~/.dsh/skills/flutter-base-framework/`
（DSH 技能中心归在 “User skills (~/.dsh/skills)”，任意 Flutter 工程可调用）。

本目录 `.dsh/skills/flutter-base-framework/` 仅保留模板/文档：其中 `SKILL.md` 的 `name`
已改为非 kebab-case 的停用值，DSH 扫描时会跳过，避免项目级同名副本遮蔽全局技能。

### 清理项目内残留（可选）

```bash
rm -rf .dsh/skills/flutter-base-framework
```

### 卸载全局技能

```bash
rm -rf ~/.dsh/skills/flutter-base-framework
```

## 使用方式

- 新对话中让 Agent 做 Flutter 页面相关工作时，技能会被自动选中；
- 也可以直接把模板文件复制进工程后改类名/接口：
  `references/templates/basic_page.dart`、`list_page.dart`、`refresh_page.dart`；
- 工程接入步骤见 `SKILL.md` 的“0. 前置检查”。

## 维护

- 框架 API 变更时，同步更新 `SKILL.md`、`references/api-cheatsheet.md` 与三个模板；
- 模板放在 `.dsh/` 隐藏目录中，与业务代码（`lib/`、`test/`）隔离；如果本包 CI 会扫描
  隐藏目录，可在 `analysis_options.yaml` 中把 `.dsh/**` 加入 `analyzer.exclude`；
- 模板中的接口路径/模型均为示例，复制到工程后需要按业务替换；
- 若把本技能复制到用户级目录，模板中的接口路径/模型同为示例。
