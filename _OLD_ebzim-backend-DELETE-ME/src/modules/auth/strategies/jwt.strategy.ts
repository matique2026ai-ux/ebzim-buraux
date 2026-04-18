import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET') || 'ebzim-secret-fallback',
    });
  }

  async validate(payload: any) {
    // This payload is decoded JWT. 
    // We attach it to the Express request object as `req.user`.
    if (!payload.sub || !payload.role) {
      throw new UnauthorizedException('Invalid token payload');
    }

    return { 
      userId: payload.sub, 
      email: payload.email, 
      role: payload.role, 
      institutionId: payload.institutionId 
    };
  }
}
