import 'package:flutter_test/flutter_test.dart';
import 'package:polyops_assessment/domain/entities/verification_status.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('VerificationDocument.isTerminal', () {
    test('true for verified', () {
      expect(makeDocument(status: VerificationStatus.verified).isTerminal, isTrue);
    });

    test('true for rejected', () {
      expect(makeDocument(status: VerificationStatus.rejected).isTerminal, isTrue);
    });

    test('false for pending', () {
      expect(makeDocument(status: VerificationStatus.pending).isTerminal, isFalse);
    });

    test('false for processing', () {
      expect(makeDocument(status: VerificationStatus.processing).isTerminal, isFalse);
    });
  });

  group('VerificationDocument.canRetry', () {
    test('true when rejected and retryCount < 3', () {
      expect(
        makeDocument(status: VerificationStatus.rejected, retryCount: 0).canRetry,
        isTrue,
      );
      expect(
        makeDocument(status: VerificationStatus.rejected, retryCount: 2).canRetry,
        isTrue,
      );
    });

    test('false when rejected but retryCount == 3', () {
      expect(
        makeDocument(status: VerificationStatus.rejected, retryCount: 3).canRetry,
        isFalse,
      );
    });

    test('false when not rejected regardless of retryCount', () {
      expect(
        makeDocument(status: VerificationStatus.pending, retryCount: 0).canRetry,
        isFalse,
      );
    });
  });

  group('VerificationDocument.resetForRetry', () {
    test('increments retryCount', () {
      final doc = makeDocument(status: VerificationStatus.rejected, retryCount: 1);
      expect(doc.resetForRetry().retryCount, 2);
    });

    test('resets status to pending and progress to 0', () {
      final doc = makeDocument(status: VerificationStatus.rejected, progress: 0.5);
      final retried = doc.resetForRetry();
      expect(retried.status, VerificationStatus.pending);
      expect(retried.progress, 0.0);
    });

    test('marks isOptimistic true and stores snapshot', () {
      final doc = makeDocument(status: VerificationStatus.rejected);
      final retried = doc.resetForRetry();
      expect(retried.isOptimistic, isTrue);
      expect(retried.optimisticSnapshot, equals(doc));
    });
  });

  group('VerificationDocument.rollback', () {
    test('returns optimisticSnapshot when present', () {
      final original = makeDocument(id: 'original');
      final optimistic = makeDocument(id: 'optimistic', isOptimistic: true)
          .copyWith(optimisticSnapshot: original);
      expect(optimistic.rollback(), equals(original));
    });

    test('returns self when no snapshot exists', () {
      final doc = makeDocument();
      expect(doc.rollback(), equals(doc));
    });
  });
}
