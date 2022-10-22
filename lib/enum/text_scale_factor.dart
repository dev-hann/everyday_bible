enum TextScaleFactor {
  small,
  medium,
  large,
}

extension FactorExtension on TextScaleFactor {
  String toName() {
    switch (this) {
      case TextScaleFactor.small:
        return "Small";
      case TextScaleFactor.medium:
        return "Medium";
      case TextScaleFactor.large:
        return "Large";
    }
  }

  double toScaleFactor() {
    switch (this) {
      case TextScaleFactor.small:
        return 0.8;
      case TextScaleFactor.medium:
        return 1.0;
      case TextScaleFactor.large:
        return 1.2;
    }
  }
}
