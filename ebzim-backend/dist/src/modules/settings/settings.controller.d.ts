import { SettingsService } from './settings.service';
export declare class SettingsController {
    private readonly settingsService;
    constructor(settingsService: SettingsService);
    getSettings(): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/settings.schema").SettingsDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/settings.schema").Settings & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    updateFee(fee: number): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/settings.schema").SettingsDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/settings.schema").Settings & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
}
