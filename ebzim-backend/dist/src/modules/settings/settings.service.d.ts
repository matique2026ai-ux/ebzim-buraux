import { OnModuleInit } from '@nestjs/common';
import { Model } from 'mongoose';
import { Settings, SettingsDocument } from './schemas/settings.schema';
export declare class SettingsService implements OnModuleInit {
    private settingsModel;
    constructor(settingsModel: Model<SettingsDocument>);
    onModuleInit(): Promise<void>;
    getSettings(): Promise<(import("mongoose").Document<unknown, {}, SettingsDocument, {}, import("mongoose").DefaultSchemaOptions> & Settings & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    updateMembershipFee(fee: number): Promise<(import("mongoose").Document<unknown, {}, SettingsDocument, {}, import("mongoose").DefaultSchemaOptions> & Settings & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
}
