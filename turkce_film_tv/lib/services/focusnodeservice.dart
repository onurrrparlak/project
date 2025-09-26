import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LeftButtonIntent extends Intent {}

class RightButtonIntent extends Intent {}

class UpButtonIntent extends Intent {}

class DownButtonIntent extends Intent {}

class EnterButtonIntent extends Intent {}

class FocusServiceProvider extends ChangeNotifier  {
  static final FocusNode loginButtonNode =
      FocusNode(debugLabel: 'loginButtonNode');
  static final FocusNode registerButtonNode =
      FocusNode(debugLabel: 'registerButtonNode');
  static final FocusNode loginEpostaNode =
      FocusNode(debugLabel: 'loginEpostaNode');
  static final FocusNode loginSifreNode =
      FocusNode(debugLabel: 'loginSifreNode');
  static final FocusNode loginLoginButtonNode =
      FocusNode(debugLabel: 'loginLoginButtonNode');
  static final FocusNode loginForgotPasswordButtonNode =
      FocusNode(debugLabel: 'loginForgotPasswordButtonNode');
  static final FocusNode registerKullaniciAdiNode =
      FocusNode(debugLabel: 'registerKullaniciAdiNode');
  static final FocusNode registerEPostaNode =
      FocusNode(debugLabel: 'registerEPostaNode');
  static final FocusNode registerPasswordNode =
      FocusNode(debugLabel: 'registerPasswordNode');
  static final FocusNode registerPasswordAgainNode =
      FocusNode(debugLabel: 'registerPasswordAgainNode');
  static final FocusNode registerRegisterButtonNode =
      FocusNode(debugLabel: 'registerRegisterButtonNode');
  static final FocusNode forgotPasswordMailNode =
      FocusNode(debugLabel: 'forgotPasswordMailNode');
  static final FocusNode forgotPasswordSubmitNode =
      FocusNode(debugLabel: 'forgotPasswordSubmitNode');
  static final FocusNode homepageMenuAnasayfaNode =
      FocusNode(debugLabel: 'homepageMenuAnasayfaNode');
  static final FocusNode homepageMenuWatchlistNode =
      FocusNode(debugLabel: 'homepageMenuWatchlistNode');
  static final FocusNode homepageMenuCategoriesNode =
      FocusNode(debugLabel: 'homepageMenuCategoriesNode');
  static final FocusNode homepageMenuSearchNode =
      FocusNode(debugLabel: 'homepageMenuSearchNode');
  static final FocusNode homepageMenuAvatarNode =
      FocusNode(debugLabel: 'homepageMenuAvatarNode');
  static final FocusNode homepagePlayNode =
      FocusNode(debugLabel: 'homepagePlayNode');
  static final FocusNode homepageAddToListNode =
      FocusNode(debugLabel: 'homepageAddToListNode');
  static final FocusNode homepageListNode =
      FocusNode(debugLabel: 'homepageListNode');
  static final FocusNode listemWillWatchNode =
      FocusNode(debugLabel: 'listemWillWatchNode');
  static final FocusNode listemWillWatchDeleteNode =
      FocusNode(debugLabel: 'listemWillWatchDeleteNode');
  static final FocusNode listenWillWatchMakeWatchedNode =
      FocusNode(debugLabel: 'listenWillWatchMakeWatchedNode');
  static final FocusNode listemWatchedNode =
      FocusNode(debugLabel: 'listemWatchedNode');
  static final FocusNode listemWatchedDeleteNode =
      FocusNode(debugLabel: 'listemWatchedDeleteNode');
  static final FocusNode listemWatchedRemoveNode =
      FocusNode(debugLabel: 'listemWatchedRemoveNode');
  static final FocusNode avatarCurrentPasswordNode =
      FocusNode(debugLabel: 'avatarCurrentPasswordNode');
  static final FocusNode avatarNewPasswordNode =
      FocusNode(debugLabel: 'avatarNewPasswordNode');
  static final FocusNode avatarUpdateSubmitNode =
      FocusNode(debugLabel: 'avatarUpdateSubmitNode');
  static final FocusNode avatarLogOutNode =
      FocusNode(debugLabel: 'avatarLogOutNode');
  static final FocusNode avatarGridViewBuilderNode =
      FocusNode(debugLabel: 'avatarGridViewBuilderNode');
  static final FocusNode categoryMenuNode =
      FocusNode(debugLabel: 'categoryMenuNode');

  void disposeAll() {
    loginButtonNode.dispose();
    registerButtonNode.dispose();
    loginEpostaNode.dispose();
    loginSifreNode.dispose();
    loginLoginButtonNode.dispose();
    loginForgotPasswordButtonNode.dispose();
    registerKullaniciAdiNode.dispose();
    registerEPostaNode.dispose();
    registerPasswordNode.dispose();
    registerPasswordAgainNode.dispose();
    registerRegisterButtonNode.dispose();
    forgotPasswordMailNode.dispose();
    forgotPasswordSubmitNode.dispose();
    homepageMenuAnasayfaNode.dispose();
    homepageMenuWatchlistNode.dispose();
    homepageMenuCategoriesNode.dispose();
    homepageMenuSearchNode.dispose();
    homepageMenuAvatarNode.dispose();
    homepagePlayNode.dispose();
    homepageAddToListNode.dispose();
    homepageListNode.dispose();
    listemWillWatchNode.dispose();
    listemWillWatchDeleteNode.dispose();
    listenWillWatchMakeWatchedNode.dispose();
    listemWatchedNode.dispose();
    listemWatchedDeleteNode.dispose();
    listemWatchedRemoveNode.dispose();
    avatarCurrentPasswordNode.dispose();
    avatarNewPasswordNode.dispose();
    avatarUpdateSubmitNode.dispose();
    avatarLogOutNode.dispose();
    avatarGridViewBuilderNode.dispose();
    categoryMenuNode.dispose();
  }

  static final LogicalKeySet arrowLeftKeySet =
      LogicalKeySet(LogicalKeyboardKey.arrowLeft);
  static final LogicalKeySet arrowRightKeySet =
      LogicalKeySet(LogicalKeyboardKey.arrowRight);
  static final LogicalKeySet arrowUpKeySet =
      LogicalKeySet(LogicalKeyboardKey.arrowUp);
  static final LogicalKeySet arrowDownKeySet =
      LogicalKeySet(LogicalKeyboardKey.arrowDown);
  static final LogicalKeySet selectKeySet =
      LogicalKeySet(LogicalKeyboardKey.select);

  static final Map<LogicalKeySet, Intent> shortcuts = <LogicalKeySet, Intent>{
    arrowLeftKeySet: LeftButtonIntent(),
    arrowRightKeySet: RightButtonIntent(),
    arrowUpKeySet: UpButtonIntent(),
    arrowDownKeySet: DownButtonIntent(),
    selectKeySet: EnterButtonIntent(),
  };


  void changeFocus(BuildContext context, FocusNode focusNode) async {
    // Current Focus Node: ${FocusScope.of(context).focusedChild}
    // Node to be Focused: $focusNode

    FocusScope.of(context).requestFocus(focusNode);

    // Delay a bit to allow focus change to process
    await Future.delayed(const Duration(milliseconds: 100));

    if (focusNode.hasFocus) {
      // focusNode.debugLabel
    } else {
      // Failed to focus on: $focusNode
    }

    notifyListeners(); // Notify listeners after the focus changes
  }


}