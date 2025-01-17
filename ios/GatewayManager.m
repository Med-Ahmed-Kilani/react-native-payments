#import "GatewayManager.h"

#if __has_include(<Stripe/Stripe.h>)
#import <Stripe/Stripe.h>
#endif


@implementation GatewayManager

+ (NSArray *)getSupportedGateways
{
    NSMutableArray *supportedGateways = [NSMutableArray array];

#if __has_include(<Stripe/Stripe.h>)
    [supportedGateways addObject:@"stripe"];
#endif


    return [supportedGateways copy];
}

- (void)configureGateway:(NSDictionary *_Nonnull)gatewayParameters
      merchantIdentifier:(NSString *_Nonnull)merchantId
{
#if __has_include(<Stripe/Stripe.h>)
    if ([gatewayParameters[@"gateway"] isEqualToString:@"stripe"]) {
        [self configureStripeGateway:gatewayParameters merchantIdentifier:merchantId];
    }
#endif
}

- (void)createTokenWithPayment:(PKPayment *_Nonnull)payment
                    completion:(void (^_Nullable)(NSString * _Nullable token, NSError * _Nullable error))completion
{
#if __has_include(<Stripe/Stripe.h>)
    [self createStripeTokenWithPayment:payment completion:completion];
#endif

}

// Stripe
- (void)configureStripeGateway:(NSDictionary *_Nonnull)gatewayParameters
            merchantIdentifier:(NSString *_Nonnull)merchantId
{
#if __has_include(<Stripe/Stripe.h>)
    NSString *stripePublishableKey = gatewayParameters[@"stripe:publishableKey"];
    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:stripePublishableKey];
    [[STPPaymentConfiguration sharedConfiguration] setAppleMerchantIdentifier:merchantId];
#endif
}

- (void)createStripeTokenWithPayment:(PKPayment *)payment completion:(void (^)(NSString * _Nullable, NSError * _Nullable))completion
{
#if __has_include(<Stripe/Stripe.h>)
    [[STPAPIClient sharedClient] createTokenWithPayment:payment completion:^(STPToken * _Nullable token, NSError * _Nullable error)
    {
        if (error) {
            completion(nil, error);
        } else {
            completion(token.tokenId, nil);
        }
    }];
#endif
}


@end
