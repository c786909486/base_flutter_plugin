"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = activate;
exports.deactivate = deactivate;
const vscode = __importStar(require("vscode"));
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
// 命名转换工具
class NameUtils {
    // 下划线命名转大驼峰
    static toPascalCase(snakeCase) {
        return snakeCase
            .split('_')
            .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
            .join('');
    }
    // 大驼峰转下划线命名
    static toSnakeCase(pascalCase) {
        return pascalCase
            .replace(/([A-Z])/g, '_$1')
            .toLowerCase()
            .replace(/^_/, '');
    }
    // 验证是否为有效的Dart标识符
    static isValidDartIdentifier(name) {
        return /^[a-zA-Z_][a-zA-Z0-9_]*$/.test(name);
    }
}
// 模板生成器
class TemplateGenerator {
    // 生成 BaseViewModel 模板
    static generateBaseViewModel(viewModelName, pageName) {
        const className = NameUtils.toPascalCase(viewModelName);
        return `import 'package:base_flutter/base_flutter.dart';

class ${className} extends BaseViewModel {
  ${className}(BuildContext context) : super(context);

  // TODO: 定义状态变量

  @override
  void init() {
    // 初始化变量
  }

  @override
  void onCreated() {
    // View 创建完成后，可以发起网络请求
    requestData();
  }

  Future<void> requestData() async {
    showLoadingDialog();
    try {
      // TODO: 发起网络请求
      // var data = await HttpGo.instance.getData("...");
      hideDialog();
      showContent();
    } catch (e) {
      hideDialog();
      showErrorState(e.toNetError());
    }
  }

  @override
  void onDispose() {
    // 清理资源
    super.onDispose();
  }
}
`;
    }
    // 生成 BaseListViewModel 模板
    static generateBaseListViewModel(viewModelName, pageName) {
        const className = NameUtils.toPascalCase(viewModelName);
        return `import 'package:base_flutter/base_flutter.dart';

class ${className} extends BaseListViewModel<dynamic> {
  ${className}(BuildContext context) : super(context);

  // TODO: 定义列表项类型

  @override
  Future<List<dynamic>> requestListData() async {
    // TODO: 发起网络请求获取列表数据
    // var data = await HttpGo.instance.getData(
    //   "https://api.example.com/list",
    //   params: {'page': page, 'pageSize': pageLength},
    // );
    // return (data['list'] as List).map((e) => ItemModel.fromJson(e)).toList();
    return [];
  }

  @override
  void onCreated() {
    super.onCreated();
    requestRefresh(showAni: false);
  }
}
`;
    }
    // 生成 basePage 模板
    static generateBasePage(viewModelName, pageName) {
        const widgetName = NameUtils.toPascalCase(pageName);
        const viewModelClassName = NameUtils.toPascalCase(viewModelName);
        return `import 'package:base_flutter/base_flutter.dart';

class ${widgetName} extends BaseStatefulMvvmWidget {
  const ${widgetName}({super.key});

  @override
  State<StatefulWidget> createState() => _${widgetName}State();
}

class _${widgetName}State extends BaseMvvmState<${viewModelClassName}, ${widgetName}> {
  @override
  ${viewModelClassName} createViewModel() => ${viewModelClassName}(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('${widgetName}'),
      body: loadingContentWidget,
    );
  }

  @override
  Widget? buildLoadingContentView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: 构建页面内容
          const Text('Hello World'),
        ],
      ),
    );
  }

  @override
  void onRetryClick() {
    viewModel.requestData();
  }
}
`;
    }
    // 生成 listPage 模板
    static generateListPage(viewModelName, pageName) {
        const widgetName = NameUtils.toPascalCase(pageName);
        const viewModelClassName = NameUtils.toPascalCase(viewModelName);
        return `import 'package:base_flutter/base_flutter.dart';

class ${widgetName} extends BaseStatefulMvvmWidget {
  const ${widgetName}({super.key});

  @override
  State<StatefulWidget> createState() => _${widgetName}State();
}

class _${widgetName}State extends BaseMvvmListState<${viewModelClassName}, ${widgetName}> {
  @override
  ${viewModelClassName} createViewModel() => ${viewModelClassName}(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('${widgetName}'),
      body: loadingContentWidget,
    );
  }

  @override
  Widget createItemWidget(int index) {
    var item = viewModel.listItems[index];
    return ListTile(
      // TODO: 构建列表项
      title: CommonText('Item \$index'),
      onTap: () {
        // TODO: 点击事件
      },
    );
  }

  @override
  bool get canPullUp => true;
}
`;
    }
    // 生成 refreshPage 模板
    static generateRefreshPage(viewModelName, pageName) {
        const widgetName = NameUtils.toPascalCase(pageName);
        const viewModelClassName = NameUtils.toPascalCase(viewModelName);
        return `import 'package:base_flutter/base_flutter.dart';

class ${widgetName} extends BaseStatefulMvvmWidget {
  const ${widgetName}({super.key});

  @override
  State<StatefulWidget> createState() => _${widgetName}State();
}

class _${widgetName}State extends BaseMvvmRefreshState<${viewModelClassName}, ${widgetName}> {
  @override
  ${viewModelClassName} createViewModel() => ${viewModelClassName}(context);

  @override
  Widget buildRootView(BuildContext context, Widget loadingContentWidget) {
    return Scaffold(
      appBar: CommonAppBar('${widgetName}'),
      body: loadingContentWidget,
    );
  }

  @override
  Widget createScrollWidget() {
    return Column(
      children: [
        // TODO: 构建可刷新内容
        const Center(
          child: Text('Pull down to refresh'),
        ),
      ],
    );
  }

  @override
  void onRetryClick() {
    viewModel.requestData();
  }
}
`;
    }
}
// 扩展激活
function activate(context) {
    console.log('Base Flutter Generator is now active');
    // 注册命令
    let disposable = vscode.commands.registerCommand('base-flutter.newPage', async (uri) => {
        // 获取当前工作区
        const workspaceFolders = vscode.workspace.workspaceFolders;
        if (!workspaceFolders) {
            vscode.window.showErrorMessage('请打开一个工作区');
            return;
        }
        // 确定目标目录
        let targetDir;
        if (uri && uri.fsPath) {
            targetDir = uri.fsPath;
        }
        else {
            targetDir = workspaceFolders[0].uri.fsPath;
        }
        // 检查是否为目录
        const stat = fs.statSync(targetDir);
        if (!stat.isDirectory()) {
            targetDir = path.dirname(targetDir);
        }
        // 输入页面名称
        const pageName = await vscode.window.showInputBox({
            prompt: '输入页面名称',
            placeHolder: '例如: home_page',
            validateInput: (value) => {
                if (!value) {
                    return '页面名称不能为空';
                }
                if (!NameUtils.isValidDartIdentifier(NameUtils.toPascalCase(value))) {
                    return '请输入有效的页面名称（字母、数字、下划线）';
                }
                return null;
            }
        });
        if (!pageName) {
            return;
        }
        // 输入 ViewModel 名称
        const defaultViewModelName = pageName.replace('_page', '_view_model').replace('_page', '_vm');
        const viewModelName = await vscode.window.showInputBox({
            prompt: '输入 ViewModel 名称',
            placeHolder: `例如: ${defaultViewModelName}`,
            value: defaultViewModelName,
            validateInput: (value) => {
                if (!value) {
                    return 'ViewModel 名称不能为空';
                }
                if (!NameUtils.isValidDartIdentifier(NameUtils.toPascalCase(value))) {
                    return '请输入有效的 ViewModel 名称（字母、数字、下划线）';
                }
                return null;
            }
        });
        if (!viewModelName) {
            return;
        }
        // 选择 ViewModel 类型
        const viewModelType = await vscode.window.showQuickPick([
            { label: 'BaseViewModel', description: '基础 ViewModel，适用于普通页面' },
            { label: 'BaseListViewModel', description: '列表 ViewModel，适用于分页列表页面' }
        ], {
            placeHolder: '选择 ViewModel 类型'
        });
        if (!viewModelType) {
            return;
        }
        // 选择页面类型
        const pageType = await vscode.window.showQuickPick([
            { label: 'basePage', description: '基础页面，包含加载状态管理' },
            { label: 'listPage', description: '列表页面，包含下拉刷新和上拉加载' },
            { label: 'refreshPage', description: '刷新页面，包含下拉刷新功能' }
        ], {
            placeHolder: '选择页面类型'
        });
        if (!pageType) {
            return;
        }
        // 生成文件名
        const viewModelFileName = NameUtils.toSnakeCase(viewModelName) + '.dart';
        const pageFileName = NameUtils.toSnakeCase(pageName) + '.dart';
        // 检查文件是否已存在
        const viewModelPath = path.join(targetDir, viewModelFileName);
        const pagePath = path.join(targetDir, pageFileName);
        if (fs.existsSync(viewModelPath)) {
            const overwrite = await vscode.window.showWarningMessage(`ViewModel 文件已存在: ${viewModelFileName}`, '覆盖', '取消');
            if (overwrite !== '覆盖') {
                return;
            }
        }
        if (fs.existsSync(pagePath)) {
            const overwrite = await vscode.window.showWarningMessage(`页面文件已存在: ${pageFileName}`, '覆盖', '取消');
            if (overwrite !== '覆盖') {
                return;
            }
        }
        // 生成文件内容
        let viewModelContent;
        if (viewModelType.label === 'BaseListViewModel') {
            viewModelContent = TemplateGenerator.generateBaseListViewModel(viewModelName, pageName);
        }
        else {
            viewModelContent = TemplateGenerator.generateBaseViewModel(viewModelName, pageName);
        }
        let pageContent;
        switch (pageType.label) {
            case 'listPage':
                pageContent = TemplateGenerator.generateListPage(viewModelName, pageName);
                break;
            case 'refreshPage':
                pageContent = TemplateGenerator.generateRefreshPage(viewModelName, pageName);
                break;
            default:
                pageContent = TemplateGenerator.generateBasePage(viewModelName, pageName);
        }
        // 写入文件
        try {
            fs.writeFileSync(viewModelPath, viewModelContent, 'utf-8');
            fs.writeFileSync(pagePath, pageContent, 'utf-8');
            vscode.window.showInformationMessage(`已创建:\n${viewModelFileName}\n${pageFileName}`);
            // 打开创建的文件
            const viewModelDoc = await vscode.workspace.openTextDocument(viewModelPath);
            await vscode.window.showTextDocument(viewModelDoc);
            const pageDoc = await vscode.workspace.openTextDocument(pagePath);
            await vscode.window.showTextDocument(pageDoc);
        }
        catch (error) {
            vscode.window.showErrorMessage(`创建文件失败: ${error}`);
        }
    });
    context.subscriptions.push(disposable);
}
// 扩展停用
function deactivate() { }
//# sourceMappingURL=extension.js.map