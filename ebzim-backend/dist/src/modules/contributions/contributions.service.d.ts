import { Model, Types } from 'mongoose';
import { Contribution, ContributionDocument } from './schemas/contribution.schema';
import { SettingsService } from '../settings/settings.service';
export declare class ContributionsService {
    private contributionModel;
    private readonly settingsService;
    constructor(contributionModel: Model<ContributionDocument>, settingsService: SettingsService);
    submitContribution(userId: string, dto: any): Promise<import("mongoose").Document<unknown, {}, ContributionDocument, {}, import("mongoose").DefaultSchemaOptions> & Contribution & import("mongoose").Document<Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    getMyContributions(userId: string): Promise<(import("mongoose").Document<unknown, {}, ContributionDocument, {}, import("mongoose").DefaultSchemaOptions> & Contribution & import("mongoose").Document<Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    getAllContributions(): Promise<(import("mongoose").Document<unknown, {}, ContributionDocument, {}, import("mongoose").DefaultSchemaOptions> & Contribution & import("mongoose").Document<Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    verifyContribution(id: string, adminId: string, status: string, notes?: string): Promise<import("mongoose").Document<unknown, {}, ContributionDocument, {}, import("mongoose").DefaultSchemaOptions> & Contribution & import("mongoose").Document<Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
}
