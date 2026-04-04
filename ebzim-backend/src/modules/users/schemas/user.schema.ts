import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { Role } from '../../../common/enums/role.enum';

export type UserDocument = User & Document;

@Schema({ _id: false })
export class UserProfile {
  @Prop()
  firstName: string;

  @Prop()
  lastName: string;

  @Prop()
  avatarUrl?: string;

  @Prop()
  bio?: string;

  @Prop()
  phone?: string;

  @Prop({ type: Types.ObjectId, ref: 'Institution' })
  institutionId?: Types.ObjectId; // Critical for AUTHORITY linkage
}

const UserProfileSchema = SchemaFactory.createForClass(UserProfile);

@Schema({ timestamps: true })
export class User {
  @Prop({ required: true, unique: true })
  email: string;

  @Prop({ required: true })
  passwordHash: string;

  @Prop({ type: String, enum: Role, default: Role.PUBLIC })
  role: Role;

  @Prop({ type: UserProfileSchema, default: {} })
  profile: UserProfile;

  @Prop({ type: String, enum: ['ACTIVE', 'INACTIVE', 'BANNED'], default: 'ACTIVE' })
  status: string;
}

export const UserSchema = SchemaFactory.createForClass(User);
