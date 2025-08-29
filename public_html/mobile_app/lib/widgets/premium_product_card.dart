import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../state/cart.dart';
import '../state/favorites_state.dart';
import '../screens/product_screen.dart';
import '../theme/app_theme.dart';

class PremiumProductCard extends StatefulWidget {
  final Product product;
  final String? imageUrl;
  final String price;
  final bool? isFavorite;
  final VoidCallback? onFavoriteToggle;

  const PremiumProductCard({
    super.key,
    required this.product,
    this.imageUrl,
    required this.price,
    this.isFavorite,
    this.onFavoriteToggle,
  });

  @override
  State<PremiumProductCard> createState() => _PremiumProductCardState();
}

class _PremiumProductCardState extends State<PremiumProductCard>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _waveController;
  late AnimationController _favoriteController;
  late AnimationController _cartController;
  
  late Animation<double> _cardScale;
  late Animation<double> _waveAnimation;
  late Animation<double> _favoriteScale;
  late Animation<double> _cartBounce;

  @override
  void initState() {
    super.initState();
    
    // 🌊 Animații pentru card
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _cardScale = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );

    // 🌊 Animații pentru undele de apă
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
    _waveController.repeat(reverse: true);

    // 💖 Animații pentru favorite
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _favoriteScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.elasticOut),
    );

    // 🛒 Animații pentru coș
    _cartController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _cartBounce = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _cartController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    _waveController.dispose();
    _favoriteController.dispose();
    _cartController.dispose();
    super.dispose();
  }

  void _onCardHover(bool isHovered) {
    if (isHovered) {
      _cardController.forward();
    } else {
      _cardController.reverse();
    }
  }

  void _onFavoriteTap() {
    _favoriteController.forward().then((_) {
      _favoriteController.reverse();
    });
  }

  void _onCartTap() {
    _cartController.forward().then((_) {
      _cartController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_cardScale, _waveAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _cardScale.value,
          child: Card(
            elevation: 16 + (_cardScale.value - 1) * 8,
            margin: const EdgeInsets.all(8),
            clipBehavior: Clip.antiAlias,
            shadowColor: AppColors.deepOcean.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: AppColors.silverScale.withOpacity(0.2 + _cardScale.value * 0.1),
                width: 1,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.crystalClear,
                    AppColors.pearlWhite,
                    AppColors.silverScale.withOpacity(0.08 + _waveAnimation.value * 0.05),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // 🌊 Efectul de undă de apă în fundal
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WavePainter(
                        waveHeight: _waveAnimation.value * 0.1,
                        color: AppColors.clearWater.withOpacity(0.05),
                      ),
                    ),
                  ),
                  
                  MouseRegion(
                    onEnter: (_) => _onCardHover(true),
                    onExit: (_) => _onCardHover(false),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductScreen(
                            productId: int.tryParse(widget.product.id) ?? 0,
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🖼️ Imaginea produsului cu efecte oceanic
                          Expanded(
                            flex: 3,
                            child: _buildProductImage(),
                          ),
                          
                          // 📝 Informațiile produsului
                          Expanded(
                            flex: 2,
                            child: _buildProductInfo(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // 💖 Butonul de favorite animat
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _buildFavoriteButton(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.clearWater.withOpacity(0.15),
            AppColors.shallowWater.withOpacity(0.08),
            AppColors.pearlWhite.withOpacity(0.9),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Stack(
          children: [
            // Imaginea principală
            widget.imageUrl == null
                ? _buildPlaceholderImage()
                : CachedNetworkImage(
                    imageUrl: widget.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => _buildLoadingImage(),
                    errorWidget: (context, url, error) => _buildPlaceholderImage(),
                  ),
            
            // Overlay gradient pentru profunzime cu animație
            AnimatedBuilder(
              animation: _waveAnimation,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.deepOcean.withOpacity(0.1),
                      AppColors.pearlWhite.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
              builder: (context, child) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.8 + _waveAnimation.value * 0.2,
                    child: child!,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.oceanicGradient,
      ),
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: _waveAnimation.value * 0.2,
                child: Icon(
                  Icons.phishing_outlined,
                  size: 48 + _waveAnimation.value * 8,
                  color: AppColors.goldenHour,
                  shadows: [
                    Shadow(
                      color: AppColors.deepOcean.withOpacity(0.5),
                      offset: Offset(0, 2 + _waveAnimation.value * 2),
                      blurRadius: 4 + _waveAnimation.value * 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'HOOKBAITS',
                style: TextStyle(
                  color: AppColors.pearlWhite,
                  fontSize: 11 + _waveAnimation.value * 2,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: AppColors.deepOcean,
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.oceanicGradient,
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldenHour),
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Titlul produsului
          Text(
            widget.product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: AppColors.textPrimary,
              letterSpacing: 0.2,
              shadows: [
                Shadow(
                  color: AppColors.silverScale.withOpacity(0.3),
                  offset: const Offset(0, 0.5),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Preț și buton coș premium
          if (widget.price.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriceBadge(),
                _buildCartButton(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPriceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppColors.premiumButtonGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.stormyWater.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.goldenHour.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'LEI',
            style: TextStyle(
              color: AppColors.goldenHour,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            widget.price,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.pearlWhite,
              fontSize: 12,
              shadows: [
                Shadow(
                  color: AppColors.deepOcean,
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartButton() {
    return AnimatedBuilder(
      animation: _cartBounce,
      builder: (context, child) {
        return Transform.scale(
          scale: _cartBounce.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.seaweed,
                  AppColors.seaweed.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.seaweed.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _onCartTap();
                  final cart = context.read<CartState>();
                  cart.add(widget.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: AppColors.goldenHour),
                          const SizedBox(width: 8),
                          Expanded(child: Text('${widget.product.name} adăugat în coș')),
                        ],
                      ),
                      backgroundColor: AppColors.seaweed,
                      duration: const Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      action: SnackBarAction(
                        label: 'VEZI COȘ',
                        textColor: AppColors.goldenHour,
                        onPressed: () {
                          DefaultTabController.of(context)?.animateTo(1);
                        },
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.add_shopping_cart_rounded,
                    color: AppColors.pearlWhite,
                    size: 18,
                    shadows: [
                      Shadow(
                        color: AppColors.deepOcean.withOpacity(0.5),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteButton() {
    return Consumer<FavoritesState>(
      builder: (context, favorites, child) {
        final isFavorite = widget.isFavorite ?? favorites.isFavorite(widget.product);
        return AnimatedBuilder(
          animation: _favoriteScale,
          builder: (context, child) {
            return Transform.scale(
              scale: _favoriteScale.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: isFavorite 
                      ? AppColors.coralGradient
                      : LinearGradient(
                          colors: [
                            AppColors.pearlWhite.withOpacity(0.95),
                            AppColors.silverScale.withOpacity(0.8),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: isFavorite 
                          ? AppColors.coral.withOpacity(0.4)
                          : AppColors.deepOcean.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: isFavorite 
                        ? AppColors.goldenHour.withOpacity(0.6)
                        : AppColors.silverScale.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      _onFavoriteTap();
                      if (widget.onFavoriteToggle != null) {
                        widget.onFavoriteToggle!();
                      } else {
                        await favorites.toggleFavorite(widget.product);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    isFavorite ? Icons.heart_broken : Icons.favorite,
                                    color: AppColors.goldenHour,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      isFavorite 
                                          ? '${widget.product.name} eliminat din favorite' 
                                          : '${widget.product.name} adăugat la favorite',
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: isFavorite ? AppColors.stormyWater : AppColors.coral,
                              duration: const Duration(seconds: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.pearlWhite : AppColors.coral,
                        size: 18,
                        shadows: isFavorite ? [
                          Shadow(
                            color: AppColors.deepOcean.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ] : null,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// 🌊 Pictor custom pentru efectele de undă
class WavePainter extends CustomPainter {
  final double waveHeight;
  final Color color;

  WavePainter({required this.waveHeight, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveWidth = size.width / 4;
    
    for (double x = 0; x <= size.width; x += waveWidth) {
      if (x == 0) {
        path.moveTo(x, size.height * 0.8 + waveHeight * 20);
      } else {
        path.quadraticBezierTo(
          x - waveWidth / 2,
          size.height * 0.8 + waveHeight * 40,
          x,
          size.height * 0.8 + waveHeight * 20,
        );
      }
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
